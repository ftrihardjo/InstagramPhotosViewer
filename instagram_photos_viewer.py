from requests import get
from selenium.webdriver import Chrome
from sys import argv, exit
from time import sleep
from tkinter import Canvas,Button,Scrollbar,RIGHT,Y,LEFT,BOTH,YES,Tk,NW,mainloop
from PIL import Image
from PIL.ImageTk import PhotoImage
from math import ceil
from io import BytesIO
from joblib import Parallel,delayed
class Instagram_Callable:
    def __init__(self,url,browser):
        self.url = url
        self.browser = browser
    def __call__(self):
        self.browser.get(self.url)
class Window:
    def __init__(self,parent,width,height):
        self.canvas = Canvas(parent,width=width,height=height)
        self.canvas.pack(side=LEFT,fill=BOTH,expand=YES)
        scrollbar = Scrollbar(parent,command=self.canvas.yview)
        scrollbar.pack(side=RIGHT,fill=Y)
        self.canvas.config(yscrollcommand=scrollbar.set)
        self.width = width
    def display_thumbnails(self,browser,urls_photos,columns,size):
        rows = int(ceil(len(urls_photos)/columns))
        self.canvas.config(scrollregion=(0,0,self.width,rows*size[1]))
        for row in range(rows):
            for column in range(columns):
                photo = PhotoImage(urls_photos[row*columns+column][1])
                button = Button(self.canvas,image=photo,command=Instagram_Callable(urls_photos[row*columns+column][0],browser),width=size[0],height=size[1])
                button.image = photo
                button.pack(side=LEFT,expand=YES)
                self.canvas.create_window(column*size[0],row*size[1],anchor=NW,window=button,width=size[0],height=size[1])
        mainloop()
        browser.close()
def retrieve_image_from_web(url):
    try:
        browser = Chrome('./chromedriver')
        browser.get(url)
        photo = browser.find_element_by_class_name('FFVAD').get_attribute('src')
        photo = Image.open(BytesIO(get(photo).content))
        browser.close()
        return (url,photo)
    except:
        pass
def retrieve_urls(browser):
    urls = []
    try:
        sleep(0.5)
        browser.execute_script('arguments[0].click();',browser.find_element_by_class_name('_9AhH0'))
        while True:
            try:
                urls.append(browser.current_url)
                sleep(0.5)
                browser.find_element_by_xpath("//a[contains(@class, 'RightPaginationArrow')]").click()
            except:
                break
    except:
        print('This instagram url has no content!!!')
    browser.close()
    return urls
def display(browser,height=600,width=800,size=(200,200),threads=10):
    try:
        browser.get(argv[1])
        urls_photos = Parallel(n_jobs=-1)(delayed(retrieve_image_from_web)(url) for url in retrieve_urls(browser))
        for url_photo in urls_photos:
            url_photo[1].thumbnail(size,Image.ANTIALIAS)
        if len(urls_photos) > 0:
            Window(Tk(),width,height).display_thumbnails(Chrome('./chromedriver'),urls_photos,width//size[0],size)
    except:
        print('Invalid instagram url!!!')
        browser.close()
        exit()
if __name__ == '__main__':
    if len(argv) != 2 or argv[1][:len('https://www.instagram.com/')] != 'https://www.instagram.com/':
        print("Invalid inputs entered!!!")
        exit()
    else:
        display(Chrome('./chromedriver'))