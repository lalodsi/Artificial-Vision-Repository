# -*- coding: utf-8 -*-
from Tkinter import *
import Image
import ImageTk
import ImageDraw
import ImageOps
import ImageFilter
import ImageFont
from ImageColor import getrgb
from numpy import *
from numpy.random import *
#from MLab import *
#import psyco
#psyco.full()


#i = Image.open('lena.jpg')
#a = numpy.asarray(i) # a is readonly
#i = Image.fromarray(a)
root = Tk()






scale=1/1.0
SAVE_FLAG = False


###Tracking params
dXFACTOR=1.0*0.85
dYFACTOR=1.0*0.85
XOFFSET = -40
YOFFSET = 0
cradio=70*scale

#Tracking params
##dXFACTOR=1.0*0.25
##dYFACTOR=1.0*0.20
##XOFFSET = 0
##YOFFSET = 0
##cradio=65*scale


# use a truetype font
IM_font    = ImageFont.truetype("Verdana.ttf", 20)
text_color = getrgb("royalblue")
im_color   = getrgb("yellow") 
SEQ_SPEED  = 1    # saltar frames
A0=0
L10=0
L20=0
C10=0
C20=0
TOP_FRAME=0
END_PROGRAM = False

direction = zeros(2);


def GetMoments(M):
    A=1.0
    M=M.astype(int)
    A=sum(sum(M))    
    Dx=diff(M,1,1)
    Dy=diff(M,1,0)
    mDx=sum(sum(abs(Dx)))
    mDy=sum(sum(abs(Dy)))
    X=M.shape[1]+0.0
    Y=M.shape[0]+0.0
    MARCO=(X*Y)
    
    # Longitud de Superficie   
    LX=(1+sum(1+sum(sqrt(1+(Dx**2)))))/(M.shape[0]*M.shape[1])
    LY=(1+sum(1+sum(sqrt(1+(Dy**2)))))/(M.shape[0]*M.shape[1])
    
    #Estaciones Tranversales
    PX=(1+(sum(1+sum(abs(Dx)*(fromfunction(lambda i,j:j,Dx.shape)+1)))))/(0.1+(mDx/(4.5)))
    PY=(1+(sum(1+sum(abs(Dy)*(fromfunction(lambda i,j:i,Dy.shape)+1)))))/(0.1+(mDy/(8.0)))

    #PX=-((sum(sum(M*(fromfunction(lambda i,j:j,M.shape)+1)))))/MARCO
    #PY=((sum(sum(M*(fromfunction(lambda i,j:i,M.shape)+1)))))/MARCO
    
    #Frecuencias Espaciales Transversales
    #FX=(1+sum(1+sum(abs(Dx),1)/X))
    #FY=(1+sum(1+sum(abs(Dy),0)/Y))
    #A=1
    
    FX=1
    FY=1
    return A,LX,LY,PX,PY,FX,FY


def framestr(x,tam=4):
    ceros="0"*(tam-len(str(x)))
    return ceros+str(x)

def LoadImages(primera=0,ultima=10,FilePath="",extension=".bmp",framemask=4):
    print "Cargando Secuencia...."
    global TOP_FRAME
    IMAGENES=[]
    IMMATRIX=[]
    ORIGINALS=[]
    Im=Image.open(FilePath+framestr(primera,framemask)+extension).convert('L')
    X=Im.size[0]
    Y=Im.size[1]
    for i in range(primera,ultima+1,SEQ_SPEED):
        Im = Image.open(FilePath+framestr(i,framemask)+extension).resize((int(X*scale),int(Y*scale)))
        ORIGINALS.append(Im)        
        IMAGENES.append(Im.convert('L'))
        #IMAGENES[-1]=IMAGENES[-1].resize((int(X*scale),int(Y*scale)))
        #IMMATRIX.append(fromimage(IMAGENES[-1]))
        IMMATRIX.append(asarray(IMAGENES[-1]))
        
    TOP_FRAME=len(IMAGENES)
    print "Secuencia Cargada....", TOP_FRAME, "imagenes"
    return IMAGENES,IMMATRIX,ORIGINALS

def GetDeltas(M):
    DELTAS=[]
    for i in range(len(M)-1):
        DELTAS.append( (M[i+1]-M[i])**2 )
    return DELTAS


def MatrixImage(size):
    RetMat=zeros((size[0],size[1],2))
    for i in range(0,size[0]):
        for j in range(0,size[1]):
            RetMat[i,j,0]=i
            RetMat[i,j,1]=j
    return RetMat




class Imagen(Canvas):
    def __init__(self, master, image):
        Canvas.__init__(self, master, width=image.size[0],height=image.size[1])
        image=image.convert('RGB')
        tile = ImageTk.PhotoImage(image)        
        self.create_image(0,0, image=tile, anchor=NW)
        self.tile= tile
        self.image = image


#IMLIST,IMMATRIX=LoadImages(0,6,".\\secuencias\\microt\\mic",".bmp",1)
#IMLIST,IMMATRIX=LoadImages(1,300,".\\secuencias\\secuencia_cubo_tz\\secuencia_cubo_tz_",".bmp",5)
#IMLIST,IMMATRIX=LoadImages(1,177,".\\secuencias\\derecha_izquierda_velocidad_constante\\",".bmp",5)
#IMLIST,IMMATRIX=LoadImages(0,199,".\\secuencias\\diccionario_alejandose\\",".bmp",4)

#IMLIST,IMMATRIX=LoadImages(0,299,".\\secuencias\\forma_t_acercamiento\\",".bmp",5)

#IMLIST,IMMATRIX=LoadImages(0,45,".\\secuencias\\sphere\\anim.",".ppm",2)
IMLIST,IMMATRIX,ORIGINALS=LoadImages(1,30,".\\secuencias\\micmov\\mic",".jpg",3)
#IMLIST,IMMATRIX=LoadImages(1,75,".\\secuencias\\road\\image.seq",".png",2)
#IMLIST,IMMATRIX=LoadImages(0,179,".\\secuencias\\microtx\\mic",".bmp",3)
#IMLIST,IMMATRIX,ORIGINALS=LoadImages(1,300,".\\secuencias\\secuencia_sintetica_gaussianas_traslacion_x\\secuencia_tx_",".bmp",5)
#IMLIST,IMMATRIX,ORIGINALS=LoadImages(1,300,".\\secuencias\\secuencia_sintetica_gaussianas_traslacion_y\\secuencia_ty_",".bmp",5)
#IMLIST,IMMATRIX,ORIGINALS=LoadImages(1,300,".\\secuencias\\secuencia_cubo_tx\\secuencia_cubo_tx_",".bmp",5)
#IMLIST,IMMATRIX=LoadImages(1,300,".\\secuencias\\secuencia_cubo_ty\\secuencia_cubo_ty_",".bmp",5)
#IMLIST,IMMATRIX= LoadImages(0,149,".\\secuencias\\gw_moving\\",".bmp",5)
#IMLIST,IMMATRIX=LoadImages(1,300,".\\secuencias\\secuencia_cubo_rotz\\secuencia_cubo_rotz_",".bmp",5)
#IMLIST,IMMATRIX=LoadImages(1,300,".\\secuencias\\secuencia_mixta_1\\secuencia_cubo_mixta_1_",".bmp",5)
#IMLIST,IMMATRIX=LoadImages(1,300,".\\secuencias\\secuencia_mixta_2\\secuencia_cubo_mixta_2_",".bmp",5)
#IMLIST,IMMATRIX=LoadImages(1,300,".\\secuencias\\secuencia_mixta_2\\secuencia_cubo_mixta_2_",".bmp",5)        
#IMLIST,IMMATRIX=LoadImages(1,8,".\\secuencias\\shapes\\C",".bmp",1)
#IMLIST,IMMATRIX=LoadImages(1,17,".\\secuencias\\shapes\\R",".bmp",1)
#IMLIST,IMMATRIX=LoadImages(1,9,".\\secuencias\\shapes\\L",".bmp",1)
#IMLIST,IMMATRIX,ORIGINALS=LoadImages(0,27,".\\secuencias\\ball\\ball",".jpg",3)
#IMLIST,IMMATRIX,ORIGINALS=LoadImages(0,55,".\\secuencias\\ballx\\ballx",".jpg",3)
#IMLIST,IMMATRIX,ORIGINALS=LoadImages(0,55,".\\secuencias\\bally\\ballY",".jpg",3)
#IMLIST,IMMATRIX,ORIGINALS=LoadImages(0,62,".\\secuencias\\ballxy\\ballxy",".jpg",3)

#DELTAS=GetDeltas(IMMATRIX)

Im=IMLIST[0]
#Im=ImageOps.grayscale(Im)

#Im=Im.resize((120,90))
MatrixT1=IMMATRIX[0]
print "Tam matriz ",MatrixT1.shape

cx0=(MatrixT1.shape[1]/2.0)-cradio+XOFFSET
cx1=(MatrixT1.shape[1]/2.0)+cradio+XOFFSET
cy0=(MatrixT1.shape[0]/2.0)-cradio+YOFFSET
cy1=(MatrixT1.shape[0]/2.0)+cradio+YOFFSET

dirx=int((MatrixT1.shape[1]*0.85))
diry=int((MatrixT1.shape[0]*0.85))


MatrixT0=MatrixT1
ImObj=Imagen(root,Im)
ImObj.pack()
DIRECTION=1
FRAME=0


salir=0
def start():
    root.after(100,flush)

def flush():
    global salir,Im,ImObj,root,MatrixT0,MatrixT1
    global DeltaImage,DIRECTION,FRAME
    global cx0,cx1,cy0,cy1,cx2,cx3,cy2,cy3

   
    if FRAME>=TOP_FRAME-1:
        DIRECTION=-1
        #FRAME=0
        if END_PROGRAM:
            root.quit()        
    if FRAME<=0:
        DIRECTION=1

    Im=ORIGINALS[FRAME]

    
    MatrixT0=MatrixT1
    MatrixT1=IMMATRIX[FRAME].astype(int)
    A0,LX0,LY0,PX0,PY0,FX0,FY0=GetMoments(MatrixT0)
    A1,LX1,LY1,PX1,PY1,FX1,FY1=GetMoments(MatrixT1)
    
    
    StrMomentos1.set("Delta  A:          "+str(round((A1-A0),2)))
    StrMomentos2.set("Long   X:          "+str(round((LX1-LX0),2)))
    StrMomentos3.set("Long   Y:          "+str(round((LY1-LY0),2)))
    StrMomentos4.set("Delta DX:          "+str(round((PX1-PX0),2)))
    StrMomentos5.set("Delta DY:          "+str(round((PY1-PY0),2)))


    #DeltaImage=abs((MatrixT1-MatrixT0))
    #Im=toimage(DeltaImage,cmax=255,cmin=0)
    #Im = ImageOps.colorize(Im, (0,0,255), (125,125,125))
    Im=Im.convert('RGB')
    
    #Im= ImageOps.invert(Im)
        
    ImDraw=ImageDraw.Draw(Im)
    dX=(PX1-PX0)*dXFACTOR
    dY=(PY1-PY0)*dYFACTOR   
    dL=(LY1-LY0)*sign(dX)*10
    c =(LX1/LY1)
    cp=(LX1/LY1)-(LX0/LY0)
    dZ=(LX1-LX0)+(LY1-LY0)
    #dZ=0
    
    cx0=cx0+(dX)-dZ*15
    cx1=cx1+(dX)+dZ*15
    cy0=cy0+(dY)-dZ*15
    cy1=cy1+(dY)+dZ*15
    
  
    ImDraw.rectangle([cx0+1,cy0,cx1+1,cy1],outline=im_color)
    ImDraw.rectangle([cx0-1,cy0,cx1-1,cy1],outline=im_color)
    ImDraw.rectangle([cx0,cy0+1,cx1,cy1+1],outline=im_color)
    ImDraw.rectangle([cx0,cy0-1,cx1,cy1-1],outline=im_color)

    #director
    norma =sqrt(sum([dX**2,dY**2]))
    direction_x = dX/norma*30
    direction_y = dY/norma*30
    
    if isnan(direction_x):
        direction_x=0;
    if isnan(direction_y):
        direction_y=0;
        
        
    
    print direction_x,direction_y,dX,dY
    print dirx,diry
    ImDraw.line([dirx,diry,dirx+direction_x,diry+direction_y],width=3,fill=getrgb("lime"))
    ImDraw.polygon([dirx+direction_x,diry+direction_y,dirx+direction_x,diry,dirx,diry+direction_y], fill=getrgb("lime")) 
    print "FRAME: ",FRAME,"  ",array((cx0+dL,cy0-dL,cx1-dL,cy1+dL))
    j=1
    name= ["dA","dLx","dLy","dX","dY","dZ"]
    #name= ["c","c'","dZ"]
    #measures = [c,cp,dZ]
    measures = [A1-A0,LX1-LX0,LY1-LY0,dX,-dY,dZ]
    for i in measures:        
        ImDraw.text((10,(20*j)-10),name[j-1]+":   "+str(round(i,2)), fill=text_color,font=IM_font)
        j+=1
    #print FRAME,"   ",cx0+dL,cy0-dL,cx1-dL,cy1+dL    
    #ImDraw.line([cx0-dL,cy0+dL,cx1+dL,cy1-dL],fill=255)    
    #ImDraw.line([cx0-dL,cy0+dL,cx1+dL,cy1-dL],fill=255)
    #ImDraw.line([cx0+dL,cy0-dL,cx1-dL,cy1+dL],fill=255)
    #ImDraw.line([cx0+dL,cy0-dL,cx1-dL,cy1+dL],fill=255)
    
    ImObj.tile.paste(Im)
    if SAVE_FLAG:
        Im.save("videos/sec"+str(FRAME)+".png")
    FRAME+=DIRECTION
    
    root.after(10,flush)



f = Frame()
f.pack()
StrMomentos1=StringVar()
StrMomentos1.set("  ")
StrMomentos2=StringVar()
StrMomentos2.set("  ")
StrMomentos3=StringVar()
StrMomentos3.set("  ")
StrMomentos4=StringVar()
StrMomentos4.set("  ")
StrMomentos5=StringVar()
StrMomentos5.set("  ")
LbMomentos1=Label(f,textvariable=StrMomentos1,width=70)
LbMomentos1.pack(side='bottom')
LbMomentos2=Label(f,textvariable=StrMomentos2,width=70)
LbMomentos2.pack(side='bottom')
LbMomentos3=Label(f,textvariable=StrMomentos3,width=70)
LbMomentos3.pack(side='bottom')
LbMomentos4=Label(f,textvariable=StrMomentos4,width=70)
LbMomentos4.pack(side='bottom')
LbMomentos5=Label(f,textvariable=StrMomentos5,width=70)
LbMomentos5.pack(side='bottom')

        

Button(root, text='Exit', command=root.quit).pack(side='bottom')
root.after(500,start)
root.mainloop()



root.destroy();
del root



