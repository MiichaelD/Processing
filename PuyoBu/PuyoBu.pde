import processing.core.PApplet;
import processing.core.PImage;

class Principal extends PApplet {

  int mapa[][]=new int[6][12];
  int velocidades[] = {400,390,380,370,360,350,340,330,320,310,
             300,290,280,270,260,250,240,230,220,210,
             200,190,180,170,160,150,140,130,120,110,
             100, 90, 80, 70, 60, 50, 40, 30, 20, 10};
  int puntos = 0;
  
  int posXp1 = 0, posYp1 = 0, posXp2 = 0, posYp2 = 0, tamPieza = 0, initX = 0;
  boolean generarPieza = true, caer = false, estado = true;
  int colorPieza1 = 0, colorPieza2 = 0;
  int yIni = 0, xIni = 0;
  PImage fondo, barra;
  ControlTiempo thread1;
    
  public void setup() 
  {
    orientation(PORTRAIT);  
    thread1 = new ControlTiempo(800);
    thread1.start();
    initMap();
    medidas();
    fondo    = loadImage("fondo.png");
    barra   = loadImage("barra.png");
  }
  
  public void medidas()
  {
    tamPieza = (height-200)/12;
    initX = (width-(tamPieza*6))/2;
  }
  
  public void draw() 
    {
    image(fondo,0,0,width,height);
    fill(0);
    rect(initX,100,tamPieza*6,height-200);
    image(barra,initX-50,100,50,height-200);
    image(barra,initX+tamPieza*6,100,50,height-200);
    pintarMap();
      
    if(estado)
    {
      if(generarPieza)
        {
        generarPieza();
        }
        
        if(caer)
          caer();
    }
    }
  
  void initMap()
  {
    for(int i=0; i<12; i++)
      for(int j=0; j<6; j++)
        mapa[j][i] = 0;
  }

  void generarPieza()
  {
    for(int i=0;i<6;i++)
      if(mapa[i][0]!=0)
      {
        estado = false;
        return; 
      }
    posXp1 = 2;
    posYp1 = 0;
    posXp2 = 3; 
    posYp2 = 0;
    
    colorPieza1 =  (int)random(1, 4);
    colorPieza2 =  (int)random(1, 4);
    
    mapa[posXp1][posYp1] = colorPieza1;
    mapa[posXp2][posYp2] = colorPieza2;
    
    generarPieza = false;
  }

  void pintarMap()
  {
    for(int i=0; i<12; i++)
      for(int j=0; j<6; j++)
        if(mapa[j][i]!=0)
        {
          switch(mapa[j][i])
          {
            case 1:
              fill(255,0,0);
              break;
            case 2:
              fill(0,255,0);
              break;
            case 3:
              fill(0,0,255);
              break;
            case 4:
              fill(255,0,255);
              break; 
          }
          rect(initX+j*tamPieza,100+i*tamPieza,tamPieza,tamPieza);
        }
  }

  void bajarPieza()
  {
    if(posYp1<11&&posYp2<11&&!caer)
    {
      if(posYp1==posYp2)
      {
        if(mapa[posXp1][posYp1+1]==0)
        {
          mapa[posXp1][posYp1+1] = mapa[posXp1][posYp1];
          mapa[posXp1][posYp1] = 0;
          posYp1 = posYp1+1;      
        }
        else
          caer = true;
        if(mapa[posXp2][posYp2+1]==0)
        {
          mapa[posXp2][posYp2+1] = mapa[posXp2][posYp2];
          mapa[posXp2][posYp2] = 0;
          posYp2 = posYp2+1;
        }
        else
          caer = true;
      }
      else
      {
        if(posYp1<posYp2)
        {             
          if(mapa[posXp2][posYp2+1]==0)
          {
            mapa[posXp2][posYp2+1] = mapa[posXp2][posYp2];
            mapa[posXp2][posYp2] = 0;         
            posYp2 = posYp2+1;
          }
          else
            caer = true;
            
          if(mapa[posXp1][posYp1+1]==0)
          {          
            mapa[posXp1][posYp1+1] = mapa[posXp1][posYp1];
            mapa[posXp1][posYp1] = 0;
            posYp1 = posYp1+1;      
          }
          else
            caer = true;    
        }
        else  
        {
          if(mapa[posXp1][posYp1+1]==0)
          {
            mapa[posXp1][posYp1+1] = mapa[posXp1][posYp1];
            mapa[posXp1][posYp1] = 0;
            posYp1 = posYp1+1;      
          }
          else
            caer = true;
          if(mapa[posXp2][posYp2+1]==0)
          {
            mapa[posXp2][posYp2+1] = mapa[posXp2][posYp2];
            mapa[posXp2][posYp2] = 0;
            posYp2 = posYp2+1;
          }
          else
            caer = true;    
        }
      }
    }
    else
    {
      caer = true;  
    }
  }
  
  void caer()
  {
    combos();
    
    boolean seguir = false;
    
    for(int i=0; i<12; i++)
      for(int j=0; j<6; j++)
        if(i<11)
          if(mapa[j][i]!=0)
            if(mapa[j][i+1]==0)
            {
              mapa[j][i+1] = mapa[j][i];
              mapa[j][i] = 0;
              seguir = true;
            }
    if(seguir)   
      caer();
    else
    {
      caer = false;
      generarPieza = true;
    }
  }

  void moverIzq()
  {
    if(posXp1>0&&posXp2>0)
    {
      if(posXp1<posXp2)
      {
        if(mapa[posXp1-1][posYp1]==0)
        {
          mapa[posXp1-1][posYp1] = mapa[posXp1][posYp1];
          mapa[posXp1][posYp1] = 0;
        }
        if(mapa[posXp2-1][posYp2]==0)
        {
          mapa[posXp2-1][posYp2] = mapa[posXp2][posYp2];
          mapa[posXp2][posYp2] = 0;
        }
      }
      else
      {     
        if(mapa[posXp2-1][posYp2]==0)
        {
          mapa[posXp2-1][posYp2] = mapa[posXp2][posYp2];
          mapa[posXp2][posYp2] = 0;
        }
        if(mapa[posXp1-1][posYp1]==0)
        {
          mapa[posXp1-1][posYp1] = mapa[posXp1][posYp1];
          mapa[posXp1][posYp1] = 0;
        }
      }
      posXp1 = posXp1-1;
      posXp2 = posXp2-1;
    }
  }
  
  void moverDer()
  {
    if(posXp1<5&&posXp2<5)
    {
      if(posXp1<posXp2)
      {
        if(mapa[posXp2+1][posYp2]==0)
        {
          mapa[posXp2+1][posYp2] = mapa[posXp2][posYp2];
          mapa[posXp2][posYp2] = 0;
        }
        
        if(mapa[posXp1+1][posYp1]==0)
        {
          mapa[posXp1+1][posYp1] = mapa[posXp1][posYp1];
          mapa[posXp1][posYp1] = 0;
        }
      } 
      else
      {
        if(mapa[posXp1+1][posYp1]==0)
        {
          mapa[posXp1+1][posYp1] = mapa[posXp1][posYp1];
          mapa[posXp1][posYp1] = 0;
        }
        
        if(mapa[posXp2+1][posYp2]==0)
        {
          mapa[posXp2+1][posYp2] = mapa[posXp2][posYp2];
          mapa[posXp2][posYp2] = 0;
        }
      } 
      posXp1 = posXp1+1;
      posXp2 = posXp2+1;
    }
  }

  void girar()
  {
    if(posYp1==posYp2)
    {  
      if(posXp1<posXp2)
      {
        if(posYp1>0)
        {
          mapa[posXp1][posYp1-1] = mapa[posXp2][posYp2];
          mapa[posXp2][posYp2] = 0;
          posXp2 = posXp1;
          posYp2 = posYp1-1;
        }
      }
      else
      {
        if(posYp1<11)
        {
          mapa[posXp1][posYp1+1] = mapa[posXp2][posYp2];
          mapa[posXp2][posYp2] = 0;
          posXp2 = posXp1;
          posYp2 = posYp2+1;
        }
      }
    }
    else
    {
      if(posYp2<posYp1)
      {
        if(posXp1>0)
          if(mapa[posXp1-1][posYp1]==0)
          {
            mapa[posXp1-1][posYp1] = mapa[posXp2][posYp2];
            mapa[posXp2][posYp2] = 0;
            posXp2 = posXp1-1; 
            posYp2 = posYp1;
          }
      }
      else
      {
        if(posXp1<5)
          if(mapa[posXp1+1][posYp1]==0)
          {
            mapa[posXp1+1][posYp1] = mapa[posXp2][posYp2];
            mapa[posXp2][posYp2] = 0;
            posXp2 = posXp1+1; 
            posYp2 = posYp1;
          }
      }  
    }
  }

  String combos[] = new String[10];
  int contCombo = 0, numeroDePiezaLeidaDelVector = 0;
  
  void combos()
  {
    for(int i=11; i>=0; i--)
      for(int j=0; j<6; j++)
        if(mapa[j][i]!=0)
        {     
          contCombo = 0;
          numeroDePiezaLeidaDelVector = 1;
          combos[0] = j+" "+i;
          if(recurCombo(combos[0]))
            break;
        }
    }
  
  boolean recurCombo(String vectorPrimeraPosicion)
  {
    boolean piezaMismoColor = false;
    //print(vectorPrimeraPosicion+"\n");
    String[] numeros = vectorPrimeraPosicion.split(" ");
      int x = Integer.parseInt(numeros[0]);
      int y = Integer.parseInt(numeros[1]);
    
      //Izq
      if(x>0)
        if(mapa[x-1][y]==mapa[x][y])
        {
          if(!existeLaPieza((x-1)+" "+y))
          {
            contCombo++;
            combos[contCombo] = (x-1)+" "+y;
            piezaMismoColor = true;
          }
        }      
      
      //Arb
      if(y>0)
        if(mapa[x][y-1]==mapa[x][y])
        {
          if(!existeLaPieza(x+" "+(y-1)))
          {
            contCombo++;
            combos[contCombo] = x+" "+(y-1);
            piezaMismoColor = true;
          }
        }      
      
    //Der
      if(x<5)
        if(mapa[x+1][y]==mapa[x][y])
        {
          if(!existeLaPieza((x+1)+" "+y))
          {
            contCombo++;
            combos[contCombo] = (x+1)+" "+y;
            piezaMismoColor = true;
          }
        }      
      
    //Abj
    if(y<11)
      if(mapa[x][y+1]==mapa[x][y])
      {
        if(!existeLaPieza(x+" "+(y+1)))
        {
          contCombo++;
          combos[contCombo] = x+" "+(y+1);
          piezaMismoColor = true;
        }  
      }
    
      if(piezaMismoColor)
        recurCombo(combos[numeroDePiezaLeidaDelVector++]);
      else
      {
        if(contCombo>3)
          destruirPiezas(contCombo);
        
        vectorCeros();
        return true;
      }
      return false;
  }

  void destruirPiezas(int numeroDePiezas)
  {
    for(int i=0; i<=numeroDePiezas; i++)
    {
      String[] numeros = combos[i].split(" ");
      int x = Integer.parseInt(numeros[0]);
      int y = Integer.parseInt(numeros[1]);
      mapa[x][y] = 0;      
    }
  }
  
  void vectorCeros()
  {
    for(int i=0; i<combos.length; i++)
      combos[i] = "";  
  }
  
  boolean existeLaPieza(String posPieza)
  {
    for(int i=0; i<combos.length; i++)
      if(combos[i]!=null)
        if(combos[i].equals(posPieza))
          return true;
    
    return false;
  }

  public void mousePressed() 
    {
    yIni = mouseY;    
    xIni = mouseX;
    }
  
  public void mouseReleased()
  {
    if(mouseY<yIni+50&&mouseY>yIni-50)
    {
      if(mouseX<xIni)
        moverIzq();
      if(mouseX>xIni)
        moverDer();
    }
    else
    {
      if(yIni<mouseY)
        bajarPieza();
      else
        girar();
    }
  }
  class ControlTiempo extends Thread {
     
    boolean running;           
    int wait;                  
    int count;                 
     
    ControlTiempo (int w) 
    {
      wait = w;
        running = false;
    }
     
    public void start() 
    {
      running = true;
      super.start();
    }
     
    public void run() 
    {
      while(true)
        {
        if(estado)
          bajarPieza();
        else
        {
          print("Perdiste");
          pintarMap();
        }
        try {
          sleep((long)(wait));
        } catch (Exception e) {
        }
        }
    }
     
    void quit() 
    {
      running = false;  
        interrupt();
    }
  }
}


