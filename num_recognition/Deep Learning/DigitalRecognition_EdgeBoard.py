import os
import v4l2capture
import cv2
import numpy as np
import sys, select, termios
import threading
import paddlemobile as pm
from paddlelite import *
from PIL import Image
from PIL import ImageFile

ImageFile.LOAD_TRUNCATED_IMAGES = True
camera = "/dev/video2"

def dataset(video): # 处理摄像头传回的图像数据
    lower_hsv = np.array([25, 75, 190])
    upper_hsv = np.array([40, 255, 255])
    select.select((video,), (), ())
    image_data = video.read_and_queue()
    frame = cv2.imdecode(np.frombuffer(image_data, dtype=np.uint8), cv2.IMREAD_COLOR)
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    mask0 = cv2.inRange(hsv, lowerb=lower_hsv, upperb=upper_hsv)
    mask = mask0
    img = Image.fromarray(mask)
    img = img.resize((244, 244), Image.ANTIALIAS)
    img = np.array(img).astype(np.float32)
    img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
    img = img / 255.0
    img = np.expand_dims(img, axis=0)
    img_256 = Image.fromarray(frame)
    return img_256, img

def load_model(): # 加载已经训练好的手写数字识别模型(静态图)
    path = "hand_inference_model"
    model_dir = path
    pm_config = pm.PaddleMobileConfig()
    pm_config.precision = pm.PaddleMobileConfig.Precision.FP32
    pm_config.device = pm.PaddleMobileConfig.Device.kFPGA
    pm_config.model_dir = model_dir
    pm_config.thread_num = 4
    predictor = pm.CreatePaddlePredictor(pm_config)
    return predictor

if __name__ == "__main__":
    # 打开摄像头
    video = v4l2capture.Video_device(camera)
    video.set_format(424,240, fourcc='MJPG')
    video.create_buffers(1)
    video.queue_all_buffers()
    video.start()

    # 识别部分
    predictor = load_model()

    while True:
        # 保存图像 调试用
        select.select((video,), (), ())
        image_data = video.read_and_queue()
        frame = cv2.imdecode(np.frombuffer(image_data, dtype=np.uint8), cv2.IMREAD_COLOR)
        cv2.imwrite("test.jpg", frame)

        # 图像预处理
        origin, img = dataset(video)
        tensor_img = origin.resize((244, 244), Image.BILINEAR)
        if tensor_img.mode != 'RGB':
            tensor_img = tensor_img.convert('RGB')
        tensor_img = np.array(tensor_img).astype('float32').transpose((2, 0, 1))  # HWC to CHW
        tensor = pm.PaddleTensor()
        tensor.dtype =pm.PaddleDType.FLOAT32
        tensor.shape  = (1,1,244,244)
        tensor.data = pm.PaddleBuf(tensor_img)
        paddle_data_feeds = [tensor]

        # 将图像输入神经网络并获得输出
        outputs = predictor.Run(paddle_data_feeds)

        # 处理输出结果并返回最终预测值
        output = np.array(outputs[0], copy = False)
        # print(output)
        number = np.argsort(output)
        print("The number is ", number[0][-1])


