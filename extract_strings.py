
def extract_strings(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Match 'title': 'Value'
    titles = re.findall(r"'title':\s*'([^']+)'", content)
    # Match 'description': 'Value' (handles multi-line with some common indentations)
    descriptions = re.findall(r"'description':\s*'([^']+)'", content)

    # Also handle some descriptions that might be across lines
    # e.g. 'description':
    #         'Value',
    descriptions_multiline = re.findall(r"'description':\s*\n\s*'([^']+)'", content)

    all_strings = set(titles + descriptions + descriptions_multiline)
    return sorted(list(all_strings))

if __name__ == "__main__":
    target_file = 'lib/src/screen/list_url.dart'
    if os.path.exists(target_file):
        strings = extract_strings(target_file)
        with open('extracted_strings.txt', 'w', encoding='utf-8') as out:
            for s in strings:
                out.write(s + '\n')
        print(f"Extracted {len(strings)} strings to extracted_strings.txt")
    else:
        print(f"File {target_file} not found")
