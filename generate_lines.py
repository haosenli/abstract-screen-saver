from matplotlib import pyplot as plt
import numpy as np
import imageio
from math import log2

def main():
    # write_sv(generate_frames())
    plot_lines(generate_frames())


def plot_lines(frames) -> None:
    """
    Plots the given frames
    """
    rows = 3
    columns = 4
    fig, ax = plt.subplots(rows, columns, figsize=(25, 12))
    print(frames[0])
    print(frames[1])
    for frame_count, frame in enumerate(frames):
        if (frame_count >= rows * columns):
            break
        # plot each point in frame
        for points in frame:
            ax[int(frame_count / columns), frame_count % columns].set_title(f'Frame {str(frame_count)}')
            ax[int(frame_count / columns), frame_count % columns].plot([points[0], points[2]], [points[1], points[3]], color='black')
    plt.tight_layout()
    # plt.show()
    plt.savefig('fancy_animation.png')


def generate_frames() -> list:
    """
    Returns a list of frames.
    """
    frames = []
    # spacing between each coordinate
    gap = 20
    # line borders (size should be half of desired length/width)
    x_size = 320
    y_size = 240
    left_x = 320 - x_size
    right_x = 320 + x_size
    top_y = 240 - y_size
    bottom_y = 240 + y_size
    # for testing
    # left_x = 5
    # right_x = 15
    # top_y = 5
    # bottom_y = 15
    center_coords = generate_rect(left_x, right_x, top_y, bottom_y, gap)
    borders = generate_border()
    # connect center to border coordinates
    for center in center_coords:
        frame = []
        x0 = center[0]
        y0 = center[1]
        for border in borders:
            x1 = border[0]
            y1 = border[1]
            frame.append((x0, y0, x1, y1))
        frames.append(frame)
    return frames


def generate_center(center, length) -> list:
    """
    Returns a list of center coordinates for the image from the 
    given center coordinate (tuple) and total amount of coordinates.
    """
    result = []
    for _ in range(length):
        result.append(center)
    return result


def generate_border() -> list:
    """
    Returns a list of border coordinates for the image.
    Coordinates start from the top left and goes clockwise.
    """
    # spacing between each coordinate
    gap = 20
    # line borders (640 x 480)
    left_x = 0
    right_x = 639
    top_y = 0
    bottom_y = 479
    # for testing
    # left_x = 0
    # right_x = 30
    # top_y = 0
    # bottom_y = 30
    return generate_rect(left_x, right_x, top_y, bottom_y, gap)


def generate_rect(left_x, right_x, top_y, bottom_y, gap):
    """
    Returns a list of coordinates for the given rectangle definitons.
    """
    result = []
    # top line
    for x in range(left_x, right_x, gap):
        result.append((x, top_y))
        
    # right line
    for y in range(top_y, bottom_y, gap):
        result.append((right_x, y))
    
    # bottom line
    for x in range(right_x, left_x, -1 * gap):
        result.append((x, bottom_y))    

    # left line
    for y in range(bottom_y, top_y, -1 * gap):
        result.append((left_x, y))
        
    return result


def write_sv(frames) -> None:
    """
    Generates an SystemVerilog file to animate the given frames.
    """
    # change file name here
    file_path = 'fancy_animation.sv'
    # change delay here
    delay = 5000000
    # change testbench repeat here
    repeat = 5000

    module_name = file_path.split('.')[0]
    frames_log = int(log2(len(frames))) + 1
    lines_log = int(log2(len(frames[0]))) + 1

    with open('animation.sv', 'r') as f:
        lines = f.readlines()

    # opening + fps control
    with open(file_path, 'w') as f:
        for line in lines:
            if 'EE371 22SP Lab 5 - animation.sv' in line:
                line = f' * EE371 22SP Lab 5 - {file_path}, May 18, 2022\n'
            elif 'module animation' in line:
                line = f'module {module_name}(input  logic clk, reset,\n'
            elif 'logic frame_counter;' in line:
                line = f'\tlogic [{str(frames_log)}:0] frame_counter;\n'
            elif 'logic [2:0] lines_counter' in line:
                line = f'\tlogic [{str(lines_log)}:0] lines_counter;\n'
            elif 'frame_counter <= 1' in line:
                line = f"\t\t\tframe_counter <= {str(frames_log)}'d0;\n"
            elif 'lines_counter <= 3' in line:
                line = f"\t\t\tlines_counter <= {str(lines_log)}'d0;\n"
            elif "if (delay_counter == 26'd50000000) begin" in line:
                line = f"\t\t\tif (delay_counter == 26'd{str(delay)}) begin\n"
            elif "frame_counter <= frame_counter + 1'd1" in line:
                line = f"\t\t\t\tif (frame_counter == {str(frames_log)}'d{len(frames)-1})\n" + \
                       f"\t\t\t\t\tframe_counter <= {str(frames_log)}'d0;\n" + \
                        "\t\t\t\telse\n" + \
                       f"\t\t\t\t\tframe_counter <= frame_counter + 1'd1;\n"
            elif '/* === ANIMATION FRAMES === */' in line:
                break
            f.write(line)

        # animation
        f.write('\t\t/* === ANIMATION FRAMES === */\n\n')
        for frame_count, frame in enumerate(frames):
            f.write(f'\t\t// frame {str(frame_count)}\n')
            f.write(f"\t\tif (frame_counter == {str(frames_log)}'d{str(frame_count)} && ~frame_complete && clear_done && ~reset && ~clear_start) begin\n")
            f.write("\t\t\tcolor <= 1'd1;\n")
            for line_count, line_data in enumerate(frame):
                x0, y0, x1, y1 = line_data
                f.write(f"\t\t\t// line {str(line_count)}: ({str(x0)}, {str(y0)}) -> ({str(x1)}, {str(y1)})\n")
                f.write(f"\t\t\tif (~lines_start && lines_counter == {str(lines_log)}'d{str(line_count)} && lines_done) begin\n")
                f.write(f"\t\t\t\tx0 <= 11'd{str(x0)};\n")
                f.write(f"\t\t\t\ty0 <= 11'd{str(y0)};\n")
                f.write(f"\t\t\t\tx1 <= 11'd{str(x1)};\n")
                f.write(f"\t\t\t\ty1 <= 11'd{str(y1)};\n")
                f.write("\t\t\t\tlines_start <= 1'd1;\n")
                f.write("\t\t\t\tlines_counter <= lines_counter + 1'd1;\n")
                # frame is completed condition
                if line_count == len(frame) - 1:
                    f.write('\t\t\t\t//frame is complete\n')
                    f.write(f"\t\t\t\tlines_counter <= {str(lines_log)}'d0;\n")
                    f.write("\t\t\t\tframe_complete <= 1'd1;\n")
                f.write("\t\t\tend\n")
            f.write(f"\t\tend\n")
        f.write(f"\tend\n")
        f.write(f"endmodule // {module_name}\n\n\n")

        # testbench
        for line in lines[200:]:
            if 'module animation_testbench' in line:
                line = f'module {module_name}_testbench();\n'
            elif 'animation dut' in line:
                line = f'{module_name} dut(.*);\n'
            elif 'reset <= 0; repeat(5000) @(posedge clk);' in line:
                line = f'\t\treset <= 0; repeat({str(repeat)}) @(posedge clk);'
            elif 'endmodule // animation_testbench' in line:
                line = f'endmodule // {module_name}_testbench\n'
            f.write(line)

    with open(file_path, 'r') as f:
        lines = f.readlines()
    file_length = len(lines)
    print(f'generate_lines.py: successfully created {file_path}.')
    print(f'                   > line count: {str(file_length)}')


if __name__ == '__main__':
    main()