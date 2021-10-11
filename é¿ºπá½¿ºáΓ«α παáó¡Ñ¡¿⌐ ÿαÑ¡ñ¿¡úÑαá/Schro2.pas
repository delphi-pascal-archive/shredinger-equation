{ *********************************************************************** }
{ Cette unité est dédiée à la résolution de l'équation de Schrodinger     }
{ dépendente du temps. s'agissant d'une équation qui contient des         }
{ complexes, on séparera systématiquement parties réelles et imaginaires  }
{ des vecteurs. Bien entendu, la notation sera considérablement allégée   }
{ lorsque j'aurai intégré les complexes dans la class TMatrix             }
{ *********************************************************************** }
unit Schro2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Matrix;

type
  TForm2 = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Image2: TImage;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    GroupBox3: TGroupBox;
    Button3: TButton;
    Edit7: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Button4: TButton;
    Button2: TButton;
    Timer1: TTimer;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Button5: TButton;
    Button6: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Psi0Init;
    procedure resoud(t:extended;psi:TMatrix);
    procedure evolution2D;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  psi0,Y0:TDoubleMat;
  psit,E,psi:TMatrix;
  nit:integer;
  t0,tf,t,dt:extended;
  play:boolean;

implementation

uses schro;

{$R *.dfm}

procedure TForm2.FormActivate(Sender: TObject);
begin
 form2.Refresh;
 Psi0Init;
 t:=strtofloat(edit8.text);
 dt:=strtofloat(edit9.Text);
 play:=false;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 play:=false;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
 Psi0Init;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
 play:=not play;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
 play:=false;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
 play:=false;
 t:=strtofloat(edit8.text);
 dt:=strtofloat(edit9.Text);
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
 evolution2D;
end;

procedure TForm2.Psi0Init;
var k:integer;
    w,psilarg,psidec,e1,imp,Emoy,pmax:extended;
    norm:extended;
    M1,M2,V1:TMatrix;
    En0:TDoubleMat;
begin
// Calcul de l'état initial Psi0, on place la partie réelle dans psi0[1]
// et la partie imaginaire dans psi0[2]
// Psi0 est une gaussienne modulée par une impulsion

{ ************************Calcul de l'état initial*********************** }
 psi0[1].Free;psi0[2].Free;
 psi0[1]:=TMatrix.create(1,n);psi0[2]:=TMatrix.create(1,n);
 psilarg:=strtofloat(edit1.Text);
 psidec:=strtofloat(edit2.Text);
 imp:=strtofloat(edit3.Text);
 for k:=1 to n do begin              //calcul de la gaussienne
    w:=(k-n/2)*xmax/n-psidec;
    e1:=exp(-sqr(w)/(2*sqr(psilarg)));
    psi0[1].Cells[1,k]:=e1;
 end;
 norm:=normr(psi0[1],1);
 psi0[1].SMul(1/norm);
 if checkbox1.Checked then begin
  psi0[2]:=copy(psi0[1]);            //calcul de la modulation
  M1:=smul(imp/hb,X);M2:=copy(M1);   //on donne une impulsion imp
  M1.func(cosM);M2.func(sinM);       //psi0=psi0.*exp(-i*imp*X/hb)
  Psi0[1].ArMul(M1);Psi0[2].ArMul(M2);
  M1.Destroy;M2.Destroy;
 end else  psi0[2]:=Zeros(1,n);      //pas de modulation

{ *************Calcul de l'énergie moyenne de la particule*************** }
 //On calcul <psi0|H|psi0>
 //|psi0>=sum(|Uj><Uj|psi0>)=sum(cj*|Uj>) ou les Uj sont les etats propres du système
 M1:=transpose(EtP);
 En0[1]:=mul(psi0[1],M1);En0[2]:=mul(psi0[2],M1);        //parties réelles et complexes des cj
 En0[1].func(sqrM);En0[2].func(sqrM);En0[1].Add(En0[2]); //En0 contient les coefficients |cj|^2
 En0[2].diags(EnP);                   //En0[2] contient les énergies propres du système
 Emoy:=ScalProdR(En0[2],En0[1],1,1);  //Emoy=sum([cj|*Ej) où les Ej sont les énergies propres
 label10.Caption:='Energie moyenne='+floattostr(Emoy)+'J';
  En0[1].Destroy;En0[2].Destroy;M1.Destroy;
 { ****************Initialisation de la résolution*********************** }
 {Pour accélérer le calcul on n'utilise que des vecteurs lignes, mais ceux ci représentent bien des etats
  On a      |Psi0>   =sum(cj*|Uj>) et on connait les cj et Uj
  On calcul |Psi(t)> =sum(cj*exp(-i*Ej*t/hb)*|Uj>) = sum(cj(t)*|Uj>)  }
 Y0[1].free;Y0[2].Free;E.free;
 E:=diags(EnP);
 M1:=transpose(EtP);
 Y0[1]:=mul(psi0[1],M1);           //Y0[1] contient les parties réelles des cj
 Y0[2]:=mul(psi0[2],M1);M1.Free;   //et Y0[2] les parties imaginaires
 psi:=TMatrix.create(2,n);

 { ********************Affichage de l'état initial*********************** }
 //On affiche à la fois |psi0(x)|^2 et le potentiel
  resoud(t,psi);
  pmax:=Max(psi);
  V1:=SMul(pmax/(Vmax),V);   //On s'arrange pour que le max de |psi(x,t)|^2 corresponde au max du potentiel
  psi.Cells[2]:=V1.Cells[1];V1.Destroy;
  MatToBmp(psi,image1.Width,image1.Height,dessin,2);
  image1.Canvas.Draw(0,0,dessin);
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var pmax:extended;
    V1:TMatrix;
begin
 if play then begin
  t:=t+dt;
  resoud(t,psi);
  pmax:=Max(psi);
  V1:=SMul(pmax/(Vmax),V);   //On s'arrange pour que le max de |psi(x,t)|^2 corresponde au max du potentiel
  psi.Cells[2]:=V1.Cells[1];V1.Destroy;
  MatToBmp(psi,image1.Width,image1.Height,dessin,2);
  image1.Canvas.Draw(0,0,dessin);
  label11.Caption:='Probabilité totale='+floattostr(sumR(psi,1)-1); //On vérifie que la probabilité totale vaut toujours 1
  label12.Caption:='t='+floattostr(t)+' s';
 end;
end;

procedure TForm2.resoud(t:extended;psi:TMatrix);
var M1,M2,M3,M4:TMatrix;
begin
 { ****Résolution de l'équation de Schrodinger dépendante du temps******** }
 //Il s'agit de résoudre l'équation i*hb*d(psi)/dt=H(psi) ou H est l'Hamiltonien du système
 //Connaissant les états propres de H: EtP, la résolution est simplifiée
 M1:=smul(-t/hb,E);M2:=copy(M1); //M1 et M2 contiennent les parties réelles
 M1.func(cosM);M2.func(sinM);    //et imaginaires des exp(-i*Ej*t/hb)
 M3:=armul(M1,Y0[1]);M4:=armul(M2,Y0[2]);
 M3.Sub(M4);                     //M3 contient les parties réelles de cj(t)
 M1.ArMul(Y0[2]);M2.ArMul(Y0[1]);
 M1.Add(M2);                     //M1 contient les parties imaginaires de cj(t)
 M2.Free;M4.Free;
 M2:=mul(M3,EtP);M4:=mul(M1,EtP);//M2+i*M4= |Psi(t)>
 M2.func(sqrM);M4.func(sqrM);
 M2.Add(M4);                     //on calcul [psi(x,t)|^2 = probabilité de présence de la particule
 psi.Cells[1]:=M2.Cells[1];     //et on l'enregistre dans psi
 M1.Free;M2.Free;M3.Free;M4.Free;
end;

procedure TForm2.evolution2D;
var k:integer;
    M1:TMatrix;
    t:extended;
begin
 t0:=strtofloat(edit4.Text); //instant initial
 tf:=strtofloat(edit5.Text); //instant final
 nit:=strtoint(edit6.Text);  //nombre d'itérations
 psit.Free;
 psit:=TMatrix.create(nit,n);//psit est une matrice rectangulaire dans laquelle
 M1:=TMatrix.create(1,n);    //on va mettre la fonction d'onde |psi(x,t)|^2 aux différents instants
 for k := 1 to nit do begin        //calcul de [psi> aux différents instants t
   t:=t0+(k-1)*(tf-t0)/nit;        //temps du calcul
   resoud(t,M1);                   //on calcul [psi(x,t)|^2 = probabilité de présence de la particule
   psit.Cells[k]:=M1.Cells[1];     //et on l'enregistre dans la ligne k de psit
 end;
 MatToBmp(psit,image2.Width,image2.Height,dessin,0); // on affiche l'ensemble des [psi(t)> en 2D
 image2.Canvas.Draw(0,0,dessin);
 image2.Refresh; M1.destroy;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 form2.Close;
end;

end.
