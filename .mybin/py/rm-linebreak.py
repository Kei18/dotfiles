import sys
import os

def main(argv):
    # argument check
    if len(argv) < 2:
        print('specify filename')
        return
    filename = sys.argv[1]
    if not os.path.exists(filename):
        print(f'{filename} does not exist')
        return

    with open(filename, 'r') as f:
        lines = f.readlines()
    outputs = ""
    for (k, l) in enumerate(lines):
        if l[-2:] == '\n' or (k < len(lines) - 1 and lines[k+1] == '\n'):
            outputs += l
        else:
            outputs += l.rstrip('\r\n') + " "
    print(outputs)

if __name__ == '__main__':
    main(sys.argv)
