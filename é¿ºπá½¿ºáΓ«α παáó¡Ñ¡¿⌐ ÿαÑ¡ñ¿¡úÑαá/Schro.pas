{ *********************************************************************** }
{ Calcul des états et énergies propres d'un système à 1 dimension         }
{ et résolution de l'équation de schrodinger dépendante du temps          }
{                                                                         }
{ Version   : 1.1                                                         }
{ Crée le   : 14/05/2006                                                  }
{ Objectif  : Ce premier exemple met en avant de nombreuses fonctions     )
{ disponibles dans la class TMatrix et en explicite l'utilisation         }
{ notament la construction de matrice, la diagonalisation, ainsi que les  }
{ différents types de représentation de matrices.                         }
{ Cette unité est dédiée aux calcul des etats et des énergies propres.    }
{ *********************************************************************** }

unit Schro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Matrix;

  const hb = 1.05459E-34;   //constante de planck réduite
type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Button2: TButton;
    Label8: TLabel;
    ListBox1: TListBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Edit8: TEdit;
    Label12: TLabel;
    CheckBox1: TCheckBox;
    Image3: TImage;
    Label13: TLabel;
    Button3: TButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure defpot;
    procedure CalcEPropres;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  EtP,EnP,V,X:TMatrix;
  p,m,w,Vmax,Vb,Xmax:extended;
  n:integer;
  Dessin:Tbitmap;

implementation
uses schro2;

{$R *.dfm}
procedure TForm1.FormCreate(Sender: TObject);
begin
 Dessin:=TBitmap.create;
 RadioButton2.Checked:=true;
 CalcEPropres;
end;

procedure TForm1.defpot;
var k:integer;
    a,b:extended;
begin
 //On definit le potentiel V, qui est un vecteur ligne
 V.Free;
 n:=strtoint(edit1.Text);
 Vmax:=strtofloat(edit3.text);
 Vb:=strtofloat(edit8.text);
 if radiobutton1.checked then k:=1;
 if radiobutton2.checked then k:=2;         
 if radiobutton3.checked then k:=3;
 if radiobutton4.checked then k:=4;
 if radiobutton5.checked then k:=5;
 if radiobutton6.checked then k:=6;
 case k of
  1: begin
      V:=Zeros(1,n);V.Cells[1,1]:=Vmax;V.Cells[1,n]:=Vmax;      //puit plat
     end;

  2: begin
      V:=linspace(-1,1,n);V.func(sqrM);V.SMul(Vmax);           //parabole
     end;

  3: begin
      V:=Zeros(1,n);V.Cells[1,1]:=Vmax;V.Cells[1,n]:=Vmax;      //marche
      for k := round(n/2) to n-1 do begin V.Cells[1,k]:=Vb; end;  
     end;

  4: begin
      V:=Zeros(1,n);V.Cells[1,1]:=Vmax;V.Cells[1,n]:=Vmax;      //barrière
      for k := round(n/3) to round(2*n/3) do begin V.Cells[1,k]:=Vb; end;
     end;
  5: begin
      V:=Zeros(1,n);V.Cells[1,1]:=Vmax;V.Cells[1,n]:=Vmax;
      a:=(4/sqr(n))*sqr(sqrt(Vmax)+sqrt(Vb));b:=-2*sqrt(a*Vmax); // puit en W
      for k := 2 to round(n/2) do begin V.Cells[1,k]:=a*sqr(k)+b*k+Vmax; end;
      for k := round(n/2)+1 to n-1 do V.Cells[1,k]:=V.Cells[1,round(n-k+1)];
     end;
  6: begin
      V:=Zeros(1,n);V.Cells[1,1]:=Vmax;V.Cells[1,n]:=Vmax;      //barrière inversée
      for k := 2 to round(n/3) do begin V.Cells[1,k]:=Vb; end;
      for k :=round(2*n/3) to n-1 do begin V.Cells[1,k]:=Vb; end;
     end;
 end;
end;

procedure TForm1.CalcEPropres;
var n2,k:integer;
    H,M1:TMatrix;
    QD:TDoubleMat;
begin
 //cette procedure calcul les etats propres du système et les mets dans la matrice EtP
 //et les energies propres dans la matrice EnP
 for k := 1 to 1 do begin
 defpot;     // On définit le potentiel V
 MatToBmp(V,image3.Width,image3.Height,dessin,2);
 image3.Canvas.Draw(0,0,dessin); //dessin du potentiel
 EtP.free;EnP.free;X.Free;       //On libère les ressources
 n:=strtoint(edit1.Text);        //espace discrétisé sur n points
 n2:=strtoint(edit5.Text);       //nombre d'états a afficher
 m:=strtofloat(edit2.text);      //masse de la particule
 Vmax:=strtofloat(edit3.text);   //potentiel max
 Xmax:=strtofloat(edit4.text);   //borne de l'espace

{ ************************Calcul du Hamiltonien************************** }
 M1:=Ones(3,n);           //matrice 3Xn remplie par des 1
 H:=linspace(-2,-2,n);    //vecteur ligne de taille n rempli par des -2
 M1.Cells[2]:=H.Cells[1]; //On met H dans la 2-ieme ligne de M1
 H.SpDiags(M1,1);         //On met M1 dans les 3 diagonales de H
 X:=linspace(-Xmax,Xmax,n);//X est l'espace discrétisé
 p:=2*Xmax/n;             //p est le pas spatial
 H.smul(sqr(hb)/(2*m*sqr(p)));
 //H est maintenant une matrice carré qui représente l'opérateur dérivé seconde P^2/(2*m)
 M1.SpDiags(V,0);         //On met le potentiel dans la diagonale de M1
 H.sub(M1);               //H:=H-M1
 H.SMul(-1);              //on change le signe de H

 {H est maintenant le Hamiltonien du système
  C'est une matrice symetrique  }

{ ****************Calcul des energies et etats propres******************* }
 QD:=eig(H);              //On diagonalise H
 EtP:=QD[1];              //Vecteurs propres de H = Etats propres du système
 EnP:=QD[2];              //Valeurs propres de H =  Enérgies propres du système

{**********************Affichage des résultats*************************** }
 M1.Free;
 EtP.Transpose;           //On met les etats propres de haut en bas
 M1:=func(EtP,sqrM);      //On prend le carré des etats propres=densité de probabilité de présence


 M1.ExtractMat(M1,1,n2,1,n);     //pour alléger l'affichage, on réduit la matrice
 MatToBmp(M1,image1.Width,image1.Height,dessin,0);
 image1.Canvas.Draw(0,0,dessin); //On dessine les n2 premiers Etats propres
 M1.ExtractMat(EnP,1,n2,1,n2);
 M1.Diags(M1);                   //On forme un vecteur ligne avec les n2 premières énergies propres
 label8.caption:='Emax='+floattostr(M1.Cells[1,n2])+' J';
 MatToBmp(M1,image2.Width,image2.Height,dessin,3);
 image2.Canvas.Draw(0,0,dessin); //on dessine les n2 premières énergies propres
 M1.Transpose;
 Listbox1.Items:=MattoStr(M1);   //on affiche les n2 premières énergies propres
 H.Destroy;M1.Destroy;           //On aura plus besoin de H
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 CalcEPropres;
end;

procedure TForm1.Button2Click(Sender: TObject);
var n1,n2,k:integer;
    M1:TMatrix;
begin
 //Affichage des resultats
 n:=strtoint(edit1.Text);
 n1:=strtoint(edit6.Text);
 n2:=strtoint(edit7.Text);
 if checkbox1.Checked then k:=0 else k:=2;
 M1:=ExtractMat(EtP,n1,n2,1,n);
 MatToBmp(M1,image1.Width,image1.Height,dessin,k);
 image1.Canvas.Draw(0,0,dessin);
 M1.ExtractMat(EnP,n1,n2,n1,n2);            
 M1.Diags(M1);
 label8.caption:='Emax='+floattostr(M1.Cells[1,n2-n1+1])+' J';
 MatToBmp(M1,image2.Width,image2.Height,dessin,3);
 image2.Canvas.Draw(0,0,dessin);
 M1.Destroy;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 form2.Show;
end;

end.
