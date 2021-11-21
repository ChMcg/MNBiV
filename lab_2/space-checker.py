#!/usr/bin/env python3.9
from __future__ import annotations
import sys
import re
import subprocess


def main():
    binary_name = sys.argv[1]
    # binary_name = 'lab_2/mousepad-injected'
    cmd = [ 'readelf', '--sections', binary_name ]
    data = subprocess.check_output(cmd)
    lines = data.decode('utf-8').split('\n')
    first_line = lines[0]
    sections = parse_sections(lines)
    spaces = {}
    for left, right in zip(sections[:-1], sections[1:]):
        free_space_start = left.address + left.size + 1
        free_space_end = right.address
        free_space = free_space_end - free_space_start
        if free_space <= 0: continue
        spaces[free_space] = [free_space_start, free_space_end]
        addresses = f"{hex(free_space_start)[2:]} .. {hex(free_space_end)[2:]}"
        addresses_2 = f"{hex(left.bias)[2:]} .. {hex(right.bias)[2:]}"
        s_names = f"{left.name} -> {right.name}"
        print(f"{free_space:10}: {addresses:>20} {addresses_2:>20} {s_names:^40}")
    return 0
        

class Section:
    number: int
    name: str
    s_type: str
    address: int
    bias: int
    size: int
    entity_size: int
    flags: str
    pointers: int
    info: int
    align: int

    def __init__(self, number, name, s_type, 
            address, bias, size, entity_size, 
            flags, pointers, info, align) -> None:
        self.number = number
        self.name = name
        self.s_type = s_type
        self.address = address
        self.bias = bias
        self.size = size
        self.entity_size = entity_size
        self.flags = flags
        self.pointers = pointers
        self.info = info
        self.align = align

    @staticmethod
    def parse(line1, line2) -> Section:
        match1: re.Match = re.match(r'\s*\[\s*(\d+)\]\s+([a-zA-Z-_\.]*)\s+([a-zA-Z-_\.]*)\s+([0-9a-fA-F]+)\s+([0-9a-fA-F]+)', line1)
        number = eval(f"0x{match1.group(1)}")
        name = str(match1.group(2)).strip()
        s_type = match1.group(3)
        address = eval(f"0x{match1.group(4)}")
        bias = eval(f"0x{match1.group(5)}")

        match2: re.Match = re.match(r'\s*([0-9a-fA-F]+)\s+([0-9a-fA-F]+)\s+(.*)\s+(\d+)\s+(\d+)\s+(\d+)', line2)
        size = eval(f"0x{match2.group(1)}")
        entity_size = eval(f"0x{match2.group(2)}")
        flags = str(match2.group(3)).strip()
        pointers = int(match2.group(4))
        info = int(match2.group(5))
        align = int(match2.group(6))

        return Section(number, name, s_type, 
            address, bias, size, entity_size, 
            flags, pointers, info, align)



def parse_sections(data: list[str]) -> list[Section]:
    ret = []
    for i, line in enumerate(data):
        if re.match(r'\s*\[\s*\d+\]', line):
            ret.append(Section.parse(data[i], data[i+1]))
    return ret


if __name__ == '__main__':
    main()
