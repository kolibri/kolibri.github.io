#!/usr/bin/python


import markdown
import os

in_path = './content'
out_path = './out'


def get_html_for_file(path:str) -> str:
    with open(path, "r", encoding="utf-8") as input_file:
        text = input_file.read()
    return markdown.markdown(text, extensions=['extra'])


def write_html_file(content: str, path: str):
    with open(path, "w", encoding="utf-8", errors="xmlcharrefreplace") as output_file:
        output_file.write(content)


def convert_file(in_file: str, out_file: str):
    html = render(get_html_for_file(in_file), './template/base.html')
    write_html_file(html, out_file)


def render(content: str, template_path: str):
    with open(template_path, "r", encoding="utf-8") as input_file:
        template = input_file.read()
    return template.replace('{{content}}', content).replace('{{menu}}', create_menu(in_path))


def create_menu(in_dir):
    html = '<ul>'
    for file in os.listdir(in_dir):
        full_path = os.path.join(in_dir, file)
        html += '<li>'
        if os.path.isdir(full_path):
            html += '<span>' + file + '</span>'
            html += create_menu(full_path)
        if os.path.isfile(full_path):
            title = file.replace('.md', '')
            href_base = os.path.join(*os.path.split(in_dir)[1:])
            # print(rel_path, split)
            html += '<a href="' + os.path.join(href_base, title) + '">' + title + '</a>'
        html += '</li>'

    html += '</ul>'
    return html


def convert_dir(in_dir: str, out_dir: str):
    for root, dirs, files in os.walk(in_dir):
        path = root.split(os.sep)
        for file in files:
            out_path = os.path.join(out_dir, *path[2:])
            if not os.path.exists(out_path):
                os.mkdir(out_path)
            convert_file(os.path.join(root, file), os.path.join(out_path, file.replace('.md', '.html')))


convert_dir(in_path, out_path)
