"""This file contains functions to generate .mif and .sv files.
"""
from matplotlib import pyplot as plt
from PIL import Image
from PIL import ImageFilter
from random import random
from typing import IO
import numpy as np
import os


def png_to_mif(image_path: str, file_path: str, new_width: int=None, bits: int=None) -> IO:
    """Converts a .png file to a .mif file.

    Outputs the data in the given image as a gray-scaled image to a .mif file.

    Args:
        image_path: A str representing the path of the image.
        file_path: A str representing the output file path of the .mif file.
        new_width: An optional int for scaling the image to the given width.
        bits: An optional int for turning the gray-scale values in the image
            to a lower bit depth.
    
    Returns:
        None.
    """
    img_np = png_to_ndarray(image_path=image_path, new_width=new_width, bits=bits)
    save_mif(data=img_np, file_path=file_path, bits=bits)


def png_to_sv(image_path: str, file_path: str, new_width: int=None, bits: int=None) -> IO:
    """Converts a .png file to a .sv file.

    Outputs the data in the given image as a gray-scaled image to a .sv file.

    Args:
        image_path: A str representing the path of the image.
        file_path: A str representing the output file path of the .sv file.
        new_width: An optional int for scaling the image to the given width.
        bits: An optional int for turning the gray-scale values in the image
            to a lower bit depth.
    
    Returns:
        None.
    """
    img_np = png_to_ndarray(image_path=image_path, new_width=new_width, bits=bits)
    save_sv(data=img_np, file_path=file_path, bits=bits)


def png_to_ndarray(image_path: str, new_width: int=None, new_height: int=None, bits: int=None) -> np.ndarray:
    """Converts a .png file to a gray-scale numpy array.

    Args:
        image_path: A str representing the path of the image.
        new_width: An optional int for scaling the image to the given width.
        new_height: An optional int for scaling the image to the given height.
            Defaults to scaling with the given new_width.
        bits: An optional int for specifying the bit depth of the gray-scale values.
    
    Returns:
        None.
    """
    return pil_to_ndarray(Image.open(image_path), new_width, new_height, bits)


def gif_to_ndarray(gif_path: str, new_width: int=None, new_height: int=None, bits: int=None):
    """Converts a .gif file to a list of gray-scale numpy array.

    Args:
        gif_path: A str representing the path of the gif.
        new_width: An optional int for scaling the gif to the given width.
        new_height: An optional int for scaling the gif to the given height.
            Defaults to scaling with the given new_width.
        bits: An optional int for specifying the bit depth of the gray-scale values.
    
    Returns:
        None.
    """
    result = list()
    gif = Image.open(gif_path)
    for frame_count in range(gif.n_frames):
        gif.seek(frame_count)
        result.append(pil_to_ndarray(gif, new_width, new_height, bits))
    return result


def pil_to_ndarray(pil_image: Image, new_width: int=None, new_height: int=None, bits: int=None):
    """Converts a Pillow Image object to a gray-scale numpy array.

    Args:
        pil_image: The Pillow Image object.
        new_width: An optional int for scaling the image to the given width.
        new_height: An optional int for scaling the image to the given height.
            Defaults to scaling with the given new_width.
        bits: An optional int for specifying the bit depth of the gray-scale values.
    
    Returns:
        None.
    """
    # bit depth calculation
    if bits:
        bit_depth = 2 ** bits
    else:
        bit_depth = 1
    # resize needed
    if new_width:
        if not new_height:
            width, height = pil_image.size
            new_height = int(height * new_width / width)
        # pil_image = pil_image.filter(ImageFilter.SMOOTH_MORE)
        pil_image = pil_image.resize((new_width, new_height))
    # convert to grayscaled 1D numpy array
    img_np = np.array(pil_image.convert('L'), dtype=int).reshape(-1)
    # img_np = ((img_np - img_np.min()) / (img_np.max() - img_np.min())) * 255
    # img_np = np.asarray(img_np, dtype=int)
    # convert value to color codes
    for i in range(img_np.size):
        img_np[i] = img_np[i] / (255 / bit_depth)
    # reshape back to 2D
    width, height = pil_image.size
    return img_np.reshape((height, width))


def ndarray_to_lines(data: np.ndarray) -> list:
    """Generates a list of horizontal line coordinates.

    Returns a list of horizontal line coordinates that replicates
    the image represented by the given numpy array data. A color
    value of 0 (black) is ignored for less memory usage.

    Args:
        data: A numpy array representing an image.

    Returns:
        A list of tuple representing the coordinates
        and color of horizontal lines to be drawn.
    """
    result = list()
    # get dimensions of ndarray
    height, width = data.shape
    for y in range(height):
        prev_color, prev_x, prev_y = (0, 0, y)
        for x in range(width):
            # ignore black, only store colors > 0.
            curr_color = data[y][x] # color of pixel
            # color change
            if prev_color != curr_color:
                # check if color is black
                if curr_color > 0 and x > 0:
                    result.append((prev_color, prev_x, prev_y, x-1, y))
                # update color, x, y values
                prev_color, prev_x, prev_y = (curr_color, x, y)
            # edge case, same color but horizontal line ends
            elif x == width - 1 and curr_color > 0:
                result.append((prev_color, prev_x, prev_y, x, y))
        # add a blank line to indicate height change
        result.append((0, 0, y, 0, y))
    return result


def generate_background(height: int, width: int, freq: float) -> np.ndarray:
    """Generates a black and white starry background.

    Returns a random starry background from the given values as a
    numpy ndarray containing ints. 

    Args:
        height: An int representing the height of background in pixels.
        width: An int representing the width of background in pixels.
        freq: A float representing the frequency of the stars.
    
    Returns:
        A numpy ndarray representing the generated background.
        Each value in the ndarray contains an int, representing the
        color of the pixel.
        
        Color representation:
            0 - black
            1 - white
    """
    result = np.zeros(shape=(height*width), dtype=int)
    # generates the stars
    for index in range(height*width):
        if (freq >= random()):
            result[index] = 1
    # reshape ndarray to desired shape
    return result.reshape((height, width))


def save_sv(data: np.ndarray, file_path: str,
            bits: int, words: int=None) -> IO:
    """Saves the given ndarray as a .sv RAM module.
    
    Creates or replaces a .sv RAM file from the given values.

    Args:
        data: A numpy ndarray representing pixels.
        file_path: A str representing the file path for the mif file.
        bits: An int representing the width of the bits used for memory.
        words: An optional int representing the number of words used
            for memory. Defaults to the length of the given data.
    
    Returns:
        None.
    """
    # copy data
    data_copy = data.copy().reshape(-1)
    # default word length
    if not words:
        words = int(np.log2(len(data_copy))) + int(np.log2(len(data_copy)) % 1.0 > 0.0)
    # module name
    module_name = os.path.split(file_path)[-1].split('.')[0]
    spacer = ' ' * len(f'module {module_name} (')
    # write file
    with open(file_path, 'w') as f:
        f.write(f'module {module_name} (')
        f.write(f'input  logic clk, wren, reset,\n')
        f.write(f'{spacer}input  logic [{words-1}:0] address,\n')
        f.write(f'{spacer}input  logic [{bits-1}:0] data,\n')
        f.write(f'{spacer}output logic [{bits-1}:0] q);\n\n')
        
        # memory register
        f.write(f'\t// multidimensional array for memory\n')
        f.write(f'\tlogic [{bits-1}:0] memory_array[{2**words-1}:0];\n')
        f.write(f'\tlogic init;\n\n')

        # basic logic for IO
        f.write(f'\t//logic for interacting with memory\n')
        f.write(f'\talways_ff @(posedge clk) begin\n')
        
        # initialize memory content
        f.write(f'\t\tif (reset) begin\n')
        f.write(f'\t\t\tinit <= 1;\n')
        f.write(f'\t\tend\n')
        f.write(f'\t\telse if (init) begin\n')
        f.write(f'\t\t\tinit <= 0;\n')
        for i in range(len(data_copy)):
            if (data_copy[i] != 0):
                f.write(f'\t\t\tmemory_array[{i}] <= {data_copy[i]};\n')
        f.write(f'\t\tend\n')
        f.write(f'\t\telse if (wren) begin\n')
        f.write(f'\t\t\t// write enabled, write and output memory\n')
        f.write(f'\t\t\tmemory_array[address] <= data;\n')
        f.write(f'\t\t\tq <= data;\n')
        f.write(f'\t\tend\n')
        f.write(f'\t\telse\n')
        f.write(f'\t\t\t// write disabled, output current memory\n')
        f.write(f'\t\t\tq <= memory_array[address];\n')
        f.write(f'\tend\n')

        # end module
        f.write(f'endmodule\n')


def save_mif(data: np.ndarray, file_path: str,
             bits: int, words: int=None) -> IO:
    """Saves the given ndarray as a .mif file.

    Creates or replaces a .mif file from the given values.

    Args:
        data: A numpy ndarray representing pixels.
        file_path: A str representing the output file path for the mif file.
        bits: An int representing the width of the bits used for memory.
        words: An optional int representing the number of words used
            for memory. Defaults to the length of the given data.
            Memory will be initiated to 0 if given words is longer than
            the length of the given data.
    
    Returns:
        None.
    """
    # copy data
    data_copy = data.copy().reshape(-1)
    # default word length
    if not words:
        words = len(data_copy)
    # write file
    with open(file_path, 'w') as f:
        f.write(f'WIDTH={bits};\n')
        f.write(f'DEPTH={words};\n\n')
        f.write('ADDRESS_RADIX=UNS;\n')
        f.write('DATA_RADIX=UNS;\n\n')
        f.write('CONTENT BEGIN\n')
        for i in range(words):
            if i < len(data_copy):
                f.write(f'\t{i}\t:\t{data_copy[i]};\n')
            else:
                f.write(f'\t{i}\t:\t0;\n')
        f.write('END;\n')


def ndarray_to_mem(data: np.ndarray, file_path: str,
                   color_bits: int, words: int=None) -> IO:
    """Saves the given image data as a .mem file.

    Creates or replaces a .mem file from the given values.

    Args:
        data: A numpy ndarray representing an image.
        file_path: A str representing the output file path for the .mem file.
        color_bits: An int representing the width of the bits used for color.
        words: An optional int representing the number of words used
            for memory. Defaults to the length of the given data.
            Memory will be initiated to 0 if given words is longer than
            the length of the given data.
    
    Returns:
        None.
    """
    # copy data
    data_copy = data.copy().reshape(-1)
    # default word length
    if not words:
        words = len(data_copy)
    with open(file_path, 'w') as f:
        for i in range(words):
            if i < len(data_copy):
                # (color_bits) binary value for color
                color_bin = ('{0:0' + str(color_bits) + 'b}').format(data_copy[i])
                f.write(f'{color_bin}\n')


def lines_to_mem(data: list, file_path: str, color_bits: int,
                 x_bits: int, y_bits: int, words: int=None) -> IO:
    """Saves the given line data as a .mem file.

    Creates or replaces a .mem file from the given values.

    Args:
        data: A list of numpy ndarray representing lines.
        file_path: A str representing the output file path for the .mem file.
        color_bits: An int representing the width of the bits used for color.
        x_bits: An int representing the width of the bits used
            for x coordinates.
        y_bits: An int representing the width of the bits used
            for y coordinates.
        words: An optional int representing the number of words used
            for memory. Defaults to the length of the given data.
            Memory will be initiated to 0 if given words is longer than
            the length of the given data.
    
    Returns:
        None.
    """
    # total bit width
    bits = color_bits + 2 * (x_bits + y_bits)
    # default word length
    if not words:
        words = len(data)
    with open(file_path, 'w') as f:
        # start file with zeros
        f.write(f'{"0" * (color_bits + x_bits + y_bits)}\n')
        for i in range(words + 1):
            if i < len(data):
                color, x1, y1, x2, y2 = data[i]
                color_cont = ('{0:0' + str(color_bits) + 'b}').format(color)
                # x1_cont = ('{0:0' + str(x_bits) + 'b}').format(x1)
                # y1_cont = ('{0:0' + str(y_bits) + 'b}').format(y1)
                x2_cont = ('{0:0' + str(x_bits) + 'b}').format(x2)
                y2_cont = ('{0:0' + str(y_bits) + 'b}').format(y2)
                # content = f'{color_cont}{x1_cont}{y1_cont}{x2_cont}{y2_cont}'
                content = f'{color_cont}{x2_cont}{y2_cont}'
                f.write(f'{content}\n')
            elif i == len(data):
                # always terminates with zeros to indicate end of file
                f.write(f'{"0" * (color_bits + x_bits + y_bits)}')
            else:
                f.write(f'{"0" * (color_bits + x_bits + y_bits)}\n')


# old code for different project
def asteroid_main():
    bg = generate_background(width=640, height=480, freq=0.015)
    save_sv(data=bg, file_path='background.sv', bits=4)

    fg = np.zeros((640, 480), dtype=int) # empty foreground
    # fg = np.zeros((8, 6), dtype=int)
    save_sv(data=fg, file_path='foreground.sv', bits=4)

    # fig = plt.figure(figsize=(12, 8))
    # plt.imshow(bg, aspect='auto', cmap='gray')
    # plt.show()

    ### graphics assets generation ###
    pre_dir = r'graphics_assets\pre_processed'
    post_dir = r''
    file_names = os.listdir(pre_dir)
    object_sizes = {
        'spaceship_player1' : 30,
        'spaceship_player2' : 30,
        'spaceship_enemy'   : 30,
        'spaceship_bullet'  : 4,
        'asteroid_small'    : 15,
        'asteroid_medium'   : 30,
        'asteroid_large'    : 60,
    }
    for file_name in file_names:
        name = file_name.split('.')[0]
        pre_path = os.path.join(pre_dir, file_name)
        post_path = os.path.join(post_dir, f'{name}.sv')
        png_to_sv(image_path=pre_path, file_path=post_path, new_width=object_sizes[name], bits=4)


def main():
    
    bits = 1
    # jerry.png
    jerry_path = r'C:\Users\haose\OneDrive\Desktop\jerry.png'
    jerry = png_to_ndarray(jerry_path, 640, 480, bits)
    jerry_lines = ndarray_to_lines(jerry)
    # ndarray_to_mem(data=jerry, file_path='jerry.mif', color_bits=2)
    lines_to_mem(data=jerry_lines, file_path='jerry.mif', color_bits=bits, x_bits=10, y_bits=9)
    plt.imshow(jerry, cmap='gray')
    plt.show()

    # anya.gif
    # anya_path = r'C:\Users\haose\iCloudDrive\Desktop\anya.gif'
    # anya = gif_to_ndarray(anya_path, 128, 96, bits)
    # lines = ndarray_to_lines(anya[0])
    # lines_to_mem(data=lines, file_path='anya.mem', color_bits=3, x_bits=8, y_bits=7)
    # plt.imshow(anya[0], cmap='gray')
    # plt.show()

    # test_arr = np.arange(16).reshape(4, 4)
    # print(test_arr)
    # ndarray_to_mem(test_arr, 'test.mif', 4)

if __name__ == '__main__':
    main()