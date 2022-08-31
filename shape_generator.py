from random import randint, choice

from scipy import rand

def generate_square(width: int, x_offset: int=0, y_offset: int=0):
    # x0, y0, x1, y1 format
    square = [
        (x_offset, y_offset, x_offset, y_offset + width),
        (x_offset, y_offset + width, x_offset + width, y_offset + width),
        (x_offset + width, y_offset + width, x_offset + width, y_offset),
        (x_offset + width, y_offset, x_offset, y_offset),
    ]           
    return square


def generate_triangle(top_x: int, top_y: int, width: int, flipped: bool=False):
    if flipped:
        flip = -1
    else:
        flip = 1
    tri = [
        (top_x, top_y, top_x + width // 2, top_y - flip * width),
        (top_x + width // 2, top_y - flip * width, top_x - width // 2, top_y - flip * width),
        (top_x - width // 2, top_y - flip * width, top_x, top_y),
    ]
    return tri

def generate_star(center_x: int, center_y: int, radius: int):
    star = [
        (center_x, center_y + radius, center_x + radius // 3, center_y + radius // 3),
        (center_x + radius // 3, center_y + radius // 3, center_x + radius, center_y),
        (center_x + radius, center_y, center_x + radius // 3, center_y - radius // 3),
        (center_x + radius // 3, center_y - radius // 3, center_x, center_y - radius),
        (center_x, center_y - radius, center_x - radius // 3, center_y - radius // 3),
        (center_x - radius // 3, center_y - radius // 3, center_x - radius, center_y),
        (center_x - radius, center_y, center_x - radius // 3, center_y + radius // 3),
        (center_x - radius // 3, center_y + radius // 3, center_x, center_y + radius),
    ]
    return star

def print_sv(frame):
    count = 0
    for shape in frame:
        for line in shape:
            print(f"\t\t\tif (~lines_start && lines_counter == {count} && lines_done) begin")
            print(f"\t\t\t\tx0 <= (11'd{line[0]} + x_offset) % 640;")
            print(f"\t\t\t\ty0 <= (11'd{line[1]} + y_offset) % 480;")
            print(f"\t\t\t\tx1 <= (11'd{line[2]} + x_offset) % 640;")
            print(f"\t\t\t\ty1 <= (11'd{line[3]} + y_offset) % 480;")
            print("\t\t\t\tlines_start <= 1;")
            print("\t\t\t\tlines_counter <= lines_counter + 1;")
            print("\t\t\tend")
            count += 1
    print()
    print()
    print("\t\t\t\t// frame is complete")
    print("\t\t\t\tlines_counter <= 0;")
    print("\t\t\t\tframe_complete <= 1;")
    print("\t\t\t\tx_offset <= x_offset + 20;")
    print("\t\t\t\ty_offset <= y_offset + 10;")


def save_sv(path, frame, file_count):
    with open('animation_base.sv', 'r') as f:
        lines = f.readlines()
    
    with open(path, 'w') as f:
        for line in lines:
            if "module animation_base(input  logic clk, reset," in line:
                f.write(f"module animation{file_count}(input  logic clk, reset,\n")
            elif "if (frame_counter == 1'd0 && ~frame_complete && clear_done && ~reset && ~clear_start) begin" in line:
                f.write("\t\tif (~frame_complete && clear_done && ~reset && ~clear_start) begin\n")
                break
            else:
                f.write(line)
        f.write("\t\t\tcolor <= 1;\n")
        count = 0
        for shape_count, shape in enumerate(frame):
            for content_count, content in enumerate(shape):
                f.write(f"\t\t\tif (~lines_start && lines_counter == {count} && lines_done) begin\n")
                f.write(f"\t\t\t\tx0_pre <= 11'd{content[0]};\n")
                f.write(f"\t\t\t\ty0_pre <= 11'd{content[1]};\n")
                f.write(f"\t\t\t\tx1_pre <= 11'd{content[2]};\n")
                f.write(f"\t\t\t\ty1_pre <= 11'd{content[3]};\n")
                if (shape_count == len(frame) - 1) and (content_count == len(shape) - 1):
                    f.write("\t\t\t\t// frame is complete\n")
                    f.write("\t\t\t\tlines_counter <= 0;\n")
                    f.write("\t\t\t\tframe_complete <= 1;\n")
                    f.write("\t\t\t\tx_offset <= x_offset + 20;\n")
                    f.write("\t\t\t\ty_offset <= y_offset + 10;\n")
                    f.write("\t\t\tend\n")
                else:
                    f.write("\t\t\t\tlines_start <= 1;\n")
                    f.write("\t\t\t\tlines_counter <= lines_counter + 1;\n")
                    f.write("\t\t\tend\n")
                count += 1
        f.write("\t\tend\n")
        f.write("\tend\n")
        f.write("endmodule")


def main():
    frame0 = list()
    for _ in range(50):
        frame0.append(generate_square(randint(30, 120), randint(0, 500), randint(0, 300)))
    save_sv('animation0.sv', frame0, str(0))

    frame1 = list()
    for _ in range(75):
        frame1.append(generate_triangle(randint(100, 500), randint(100, 320), randint(30, 100), choice([True, False])))
    save_sv('animation1.sv', frame1, str(1))
    
    frame2 = list()
    for _ in range(50):
        frame2.append(generate_star(randint(100, 500), randint(100, 320), randint(30, 100)))
    save_sv('animation2.sv', frame2, str(2))


if __name__ == '__main__':
    main()