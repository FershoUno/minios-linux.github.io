import argparse
import os
from bs4 import BeautifulSoup
import json

def main():
    # Set up command line argument parsing
    parser = argparse.ArgumentParser(description='Replace text on a website with translated text.')
    parser.add_argument('-f', '--html-file', required=True, help='path to the html page')
    parser.add_argument('-j', '--json-file', required=True, help='path to the language json file')
    args = parser.parse_args()

    # Path to the html page
    html_file = args.html_file

    # Path to the language json file
    json_file = args.json_file

    # Create a new directory with the name of the language file (without the .json extension)
    lang_dir = os.path.splitext(os.path.basename(json_file))[0]
    os.makedirs(lang_dir, exist_ok=True)

    # Read the contents of the html file
    with open(html_file, 'r') as f:
        html_content = f.read()

    # Parse the html content using BeautifulSoup
    soup = BeautifulSoup(html_content, 'html.parser')

    # Read the contents of the json file
    with open(json_file, 'r') as f:
        translations = json.load(f)

    # Find all tags that contain text to be translated
    tags = soup.find_all(['p', 'a', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'title'])

    # Replace the text inside the tags with translated text
    for tag in tags:
        if tag.string in translations:
            tag.string = translations[tag.string]

    # Write the updated html content to a new file in the language directory
    with open(os.path.join(lang_dir, os.path.basename(html_file)), 'w') as f:
        f.write(str(soup))

    print('Text on the site successfully replaced with translated text!')

if __name__ == '__main__':
    main()
