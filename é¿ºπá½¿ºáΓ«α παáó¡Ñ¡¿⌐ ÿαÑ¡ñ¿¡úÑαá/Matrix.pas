{ *********************************************************************** }
{ Unité de calcul matriciel réel                                          }
{                                                                         }
{ Version   : 1.0                                                         }
{ Crée le   : 14/05/2006                                                  }
{ Objectifs : -Création d'une class TMatrix et définitions de différentes )
{ fonctions et opérateurs réels agissant sur ces matrices.                }
{ -Décompositions de matrices LU, QR, QL, Hessenberg.                     }
{ -Diagonalisation d'une matrice symétrique réelle.                       }
{ *********************************************************************** }

unit Matrix;

interface
uses  Classes,SysUtils,Graphics;

  const coul:array[1..10] of Tcolor = (clblue,clred,clyellow,clgreen,claqua,clpurple,clfuchsia,clLime,clNavy,clolive);
  Type Tfnc = function(v:extended):extended;

  Type TMatrix = class
  private
   FSquare  :boolean;
   Fsym     :boolean;
   FLo      :boolean;
   FUp      :boolean;
   FDiag    :boolean;
   FHess    :boolean;
   FTridiag :boolean;
   function  GetRowCount:integer;
   procedure SetRowCount(RC:integer);
   function  GetColCount:integer;
   procedure SetColCount(CC:integer);
  public
   Cells:array of array of extended;

   constructor create(RC,CC:integer);
  // destructor  destroy;  override   ;

   procedure   define;
   procedure   Transpose;
   procedure   Add(M:TMatrix);
   procedure   Sub(M:TMatrix);
   procedure   Mul(M:Tmatrix);
   procedure   LMul(M:Tmatrix);
   procedure   SMul(s:extended);
   procedure   ArMul(M:Tmatrix);
   procedure   Inv;
   procedure   func(f:Tfnc);

   procedure   Zeros(RC,CC:integer);
   procedure   Ones(RC,CC:integer);
   procedure   Eye(RC,CC:integer);
   procedure   Rand(RC,CC:integer);
   procedure   LinSpace(a,b:extended;n:integer);

   procedure   SpDiags(M:TMatrix;d:integer);
   procedure   Diags(M:TMatrix);
   procedure   ExtractMat(M:TMatrix;R1,Rn,C1,Cn:integer);

  published
   property RowCount:integer read GetRowCount write SetRowCount;
   property ColCount:integer read GetColCount write SetColCount;
   property Square  :boolean read FSquare;
   property Sym     :boolean read FSym;
   property Lo      :boolean read FLo;
   property Up      :boolean read FUp;
   property Diag    :boolean read FDiag;
   property Tridiag :boolean read FTridiag;
   property Hess    :boolean read FHess;
  end;

  Type TDoubleMat = array[1..2] of TMatrix;//sert aux décompositionx des matrices

{ ***************Opérations élémentaires sur les matrices**************** }
  function Transpose(M:TMatrix):TMatrix;
  function Add(M1,M2:TMatrix):TMatrix;
  function Sub(M1,M2:TMatrix):TMatrix;
  function Mul(M1,M2:TMatrix):TMatrix;
  function SMul(s:extended;M:TMatrix):TMatrix;
  function ArMul(M1,M2:TMatrix):TMatrix;
  function Inv(M:TMatrix):TMatrix;
  function det(M:TMatrix):extended;
  function func(M:TMatrix;f:Tfnc):TMatrix;

{ *******Création de différents types de matrices et vecteurs************ }
  function Copy(M:Tmatrix):TMatrix;
  function Rand(RC,CC:integer):TMatrix;
  function Zeros(RC,CC:integer):TMatrix;
  function Eye(RC,CC:integer):TMatrix;
  function Ones(RC,CC:integer):TMatrix;
  function LinSpace(a,b:extended;n:integer):TMatrix;
  function SpDiags(M:TMatrix;d:integer):TMatrix;
  function Diags(M:TMatrix):TMatrix;
  function ExtractMat(M:TMatrix;R1,Rn,C1,Cn:integer):TMatrix;

{ *********Définition des fonctions agissant sur des matrices************ }
{ ********************et générant des scalaires************************** }
  function NormR(M:TMatrix;R:integer):extended;
  function NormC(M:TMatrix;C:integer):extended;
  function ScalProdR(M1,M2:TMatrix;R1,R2:integer):extended;
  function ScalProdC(M1,M2:TMatrix;C1,C2:integer):extended;
  function ScalProdRC(M1,M2:TMatrix;R1,C2:integer):extended;
  function Max(M:TMatrix):extended;
  function Min(M:TMatrix):extended;
  function SumR(M:TMatrix;R:integer):extended;
  function SumC(M:TMatrix;C:integer):extended;
  function sqrM(v:extended):extended;
  function sqrtM(v:extended):extended;
  function sinM(v:extended):extended;
  function cosM(v:extended):extended;
  function expM(v:extended):extended;

{ ********************Décompositions de matrices************************* }
  function LU(M:TMatrix):TDoubleMat;
  function QR(M:TMatrix):TDoubleMat;
  function QL(M:TMatrix):TDoubleMat;
  function Hess(M:TMatrix):TDoubleMat;


{ ******************Diagonalisation de matrices************************** }
  function eigvals(M:TMatrix):TMatrix;
  function eig(M:TMatrix):TDoubleMat;
  function Schur(M:TMatrix):TDoubleMat;

{ ******************Représentations des matrices************************* }
  function MatToStr(M:TMatrix):TStringList;
  procedure MatToBmp(M:TMatrix;Width,Height:integer;bmp:Tbitmap;mode:integer);
  function Col(V:extended):integer;


implementation

{ ***********************Gestion de la matrice*************************** }

constructor TMatrix.create(RC,CC:integer);
begin
 RowCount:=RC;        
 ColCount:=CC;
end;
                                       
{destructor TMatrix.destroy;
var n:integer;
begin
 inherited;
end;}

function  TMatrix.GetRowCount:integer;
begin
 GetRowCount:=length(Cells)-1;
end;

procedure TMatrix.SetRowCount(RC:integer);
begin
 SetLength(Cells,RC+1);
end;

function  TMatrix.GetColCount:integer;
begin
 GetColCount:=length(Cells[1])-1;
end;

procedure TMatrix.SetColCount(CC:integer);
var n:integer;
begin
 for n:=1 to RowCount do begin
  SetLength(Cells[n],CC+1);
 end;
end;

function Copy(M:Tmatrix):TMatrix;
var i,j:integer;
begin
 //Copy renvoit une copie de M
 RESULT:=TMatrix.create(M.RowCount,M.ColCount);
 RESULT.FSquare:=M.FSquare;
 RESULT.FSym:=M.FSym;
 RESULT.FLo:=M.FLo;
 RESULT.FUp:=M.FUp;
 RESULT.FDiag:=M.FDiag;
 RESULT.FHess:=M.FHess;
 RESULT.FTriDiag:=M.FTriDiag;
 for i:=1 to M.RowCount do begin
  for j:=1 to M.ColCount do begin
   RESULT.Cells[i,j]:=M.Cells[i,j];
  end;
 end;
end;

procedure TMatrix.define;
var i,j,n:integer;
    a,b:extended;
begin
 //définit les propriétées de la matrice, ces propriétés sont utilisées par les
 //différentes fonctions pour choisir l'algorithme adapté au type de matrice
 n:=RowCount;
 if n=ColCount then begin
   FSquare:=True;Fsym:=True;FLo:=True;FUp:=True;
   FDiag:=True;FHess:=True;FTridiag:=True;
  for i := 1 to n do begin
   for j := 1 to n do begin
    if i<j then begin
     a:=Cells[i,j];b:=Cells[j,i];
     if a<>b then FSym:=False;
     if a<>0 then begin
      FDiag:=False;FLo:=False;
      if j>i+1  then FTridiag:=False;
     end;
    end;
    if i>j then begin
     a:=Cells[i,j];b:=Cells[j,i];
     if a<>b then FSym:=False;
     if a<>0 then begin
      FDiag:=False;FUp:=False;
      if i>j+1 then begin
       FTridiag:=False;FHess:=False;
      end;
     end;
    end;
   end;
  end;
 end else begin
  FSquare:=False;Fsym:=False;FLo:=False;FUp:=False;
  FDiag:=False;FHess:=False;FTridiag:=False;
 end;
end;

{ ***************Opérations élémentaires sur les matrices**************** }

procedure TMatrix.Transpose;
var i,j,RC,CC:integer;
    M1:TMatrix;
begin
 //calcul de la transposée
 RC:=RowCount;CC:=ColCount;
 M1:=Copy(Self);
 RowCount:=CC;ColCount:=RC;
 for i := 1 to RowCount do begin
  for j := 1 to ColCount do begin
   Cells[i,j]:=M1.Cells[j,i];
  end;
 end;
 M1.Destroy;
end;

procedure TMatrix.Add(M:TMatrix);
var i,j,RC,CC:integer;
begin
 //addition, Self:=Self+M
 RC:=M.RowCount;CC:=M.ColCount;
 for i:=1 to RC do begin
  for j:=1 to CC do begin
   Cells[i,j]:=Cells[i,j]+M.Cells[i,j];
  end;
 end;
end;

procedure TMatrix.Sub(M:TMatrix);
var i,j,RC,CC:integer;
begin
 //soustraction  Self:=Self-M
 RC:=M.RowCount;CC:=M.ColCount;
 if (RC=RowCount) and (CC=ColCount) then begin
  for i:=1 to RC do begin
   for j:=1 to CC do begin
    Cells[i,j]:=Cells[i,j]-M.Cells[i,j];
   end;
  end;
 end;
end;

procedure TMatrix.Mul(M:TMatrix);
var i,j,k,RC1,CC1,RC2,CC2:integer;
    M1ik:extended;
    M1:TMatrix;
begin
 //multiplication à droite Self:=Self*M
 RC1:=RowCount;CC1:=ColCount;
 RC2:=M.RowCount;CC2:=M.ColCount;
 if (CC1=RC2) then begin
  M1:=Copy(Self);
  RowCount:=RC1;
  ColCount:=CC2;
  for i := 1 to RC1 do begin
    for j := 1 to CC2 do begin
     Cells[i,j]:=0;
    end;
  end;
  for i:=1 to RC1 do begin
   for k:=1 to RC2 do begin
    M1ik:=M1.Cells[i,k];
    for j:=1 to CC2 do begin
     Cells[i,j]:=Cells[i,j]+M1ik*M.Cells[k,j];
    end;
   end;
  end;
  M1.Destroy;
 end;
end;

procedure TMatrix.LMul(M:Tmatrix);
var i,j,k,RC1,CC1,RC2,CC2:integer;
    M1ik:extended;
    M1:TMatrix;
begin
 //multiplication à gauche Self:=M*Self
 RC1:=RowCount;CC1:=ColCount;
 RC2:=M.RowCount;CC2:=M.ColCount;
 if (CC1=RC2) then begin
  M1:=Copy(Self);
  RowCount:=RC1;
  ColCount:=CC2;
  for i := 1 to RC1 do begin
    for j := 1 to CC2 do begin
     Cells[i,j]:=0;
    end;
  end;
  for i:=1 to RC1 do begin
   for k:=1 to RC2 do begin
    M1ik:=M.Cells[i,k];
    for j:=1 to CC2 do begin
     Cells[i,j]:=Cells[i,j]+M1ik*M1.Cells[k,j];
    end;
   end;
  end;
  M1.Destroy;
 end;
end;

procedure TMatrix.SMul(s:extended);
var i,j:integer;
begin
 //multiplication scalaire Self:=s*Self
 for i:=1 to RowCount do begin
  for j:=1 to ColCount do begin
   Cells[i,j]:=s*Cells[i,j];
  end;
 end;
end;

procedure TMatrix.ArMul(M:TMatrix);
var i,j,RC1,CC1,RC2,CC2:integer;
begin
 //multiplication des éléments des 2 matrices: aij:=aij*bij
 RC1:=RowCount;CC1:=ColCount;
 RC2:=M.RowCount;CC2:=M.ColCount;
 if (CC1=CC2) and (RC1=RC2) then begin
  for i:=1 to RC1 do begin
   for j:=1 to CC1 do begin
    Cells[i,j]:=Cells[i,j]*M.Cells[i,j];
   end;
  end;
 end;
end;

procedure TMatrix.Inv;
var i,j,l,k,n:integer;
    U:TMatrix;
    V:array of extended;
    Vsup:extended;
    label L0,L1;
begin
 { Calcul de l'inverse de la matrice Self:=1/Self
 L'algorithme effectue la factorisation Q*U*L
 Ou Q est une matrice de rotation, U une matrice triangulaire sup
 de determinant 1 et L est une matrice triang inf
 Si la matrice n'est pas inversible on renvoit nil                }

 if RowCount=ColCount then begin
  n:=RowCount;
  setlength(V,n+1);
  U:=Copy(Self);
  Self.Eye(n,n);    //M=Id

  for l:=n downto 2 do begin
   vsup:=1E-16;k:=1;
   for j:=1 to l do begin
    if abs(U.Cells[l,j])>vsup then begin
     vsup:=abs(U.Cells[l,j]);k:=j;    //On cherche le plus grand élément de la l-ieme ligne pour en faire le pivot
    end;
   end;
   if vsup=1E-16 then goto l0;      //matrice non inversible

   for i:=1 to n do begin
    V[i]:=U.Cells[i,l];
   end;
   for i:=1 to n do begin           //echange de colonnes  Cl<->Ck
    U.Cells[i,l]:=U.Cells[i,k];
    U.Cells[i,k]:=V[i];
   end;

   for i:=1 to n do begin
    V[i]:=Cells[i,l];             //On répercute l'échange sur M
   end;
   for i:=1 to n do begin
    Cells[i,l]:=Cells[i,k];
    Cells[i,k]:=V[i];
   end;

   for j := 1 to l-1 do begin
    V[j]:=-U.Cells[l,j]/U.Cells[l,l]; //définition des pivots
   end;

   for i:=1 to n do begin
    for j := 1 to l-1 do begin
     Cells[i,j]:=Cells[i,j]+V[j]*Cells[i,l];
    end;
   end;
   for i:=1 to l-1 do begin
    for j := 1 to l-1 do begin
     U.Cells[i,j]:=U.Cells[i,j]+V[j]*U.Cells[i,l]; //ligne l de l-1 zeros
    end;
   end;
  end;
  //U est triang sup
  //M=Q*U*L*Q'
  for l:=n-1 downto 1 do begin
   for j :=n-l+1 to n do begin
    if abs(U.Cells[n-l,n-l])<1E-8 then goto L0;
    V[j]:=-U.Cells[n-l,j]/U.Cells[n-l,n-l];
   end;

   for i := 1 to n do begin
    for j := n-l+1 to n do begin
     Cells[i,j]:=Cells[i,j]+V[j]*Cells[i,n-l];
    end;
   end;
  end;

  for i := 1 to n do begin
   V[i]:=1/U.Cells[i,i];
  end;
  for i:=1 to n do begin
   for j:=1 to n do begin
    Cells[i,j]:=V[j]*Cells[i,j];
   end;
  end;
  goto L1;
  L0:
   //Self:=nil;
  L1:
  U.destroy;
  setlength(V,0);
 end;// end else Self:=nil;
end;

function det(M:TMatrix):extended;
var i,j,l,k,n:integer;
    U:TMatrix;
    V:array of extended;
    Vsup:extended;
    label L0,L1;
begin
 { Calcul du determinant de M
 La méthode utilisée est également M=Q*U*L ou seul U est calculé explicitement
 les autres matrices ayant des déterminants unitaires  }
 if M.RowCount=M.ColCount then begin
  n:=M.RowCount;
  setlength(V,n+1);
  U:=Copy(M);
  RESULT:=1;
  for l:=n downto 2 do begin
   vsup:=1E-16;k:=1;
   for j:=1 to l do begin
    if abs(U.Cells[l,j])>vsup then begin
     vsup:=abs(U.Cells[l,j]);k:=j;
    end;
   end;
   if l<>k then RESULT:=-RESULT; //signature de la permutation=det(Q)=-1 ou +1

   if vsup=1E-16 then goto l0;      //matrice non inversible

   for i:=1 to n do begin
    V[i]:=U.Cells[i,l];
   end;
   for i:=1 to n do begin           //echange de colonnes  Cl<->Ck
    U.Cells[i,l]:=U.Cells[i,k];
    U.Cells[i,k]:=V[i];
   end;
   for j := 1 to l-1 do begin
    V[j]:=-U.Cells[l,j]/U.Cells[l,l];
   end;

   for i:=1 to l-1 do begin
    for j := 1 to l-1 do begin
     U.Cells[i,j]:=U.Cells[i,j]+V[j]*U.Cells[i,l];
    end;
   end;
   for j := 1 to l-1 do begin
    U.Cells[l,j]:=0;           //ligne l de l-1 zeros
   end;
  end;
  //U est triang sup
  for i := 1 to n do begin
   RESULT:=RESULT*U.Cells[i,i];
  end;
  goto L1;
  L0:
   det:=0;
  L1:
  U.destroy;
  setlength(V,0);
 end else det:=0;
end;

procedure TMatrix.func(f:Tfnc);
var i,j:integer;
begin
 //On applique une fonction à chaque élément de la matrice
 for i := 1 to RowCount do begin
  for j := 1 to ColCount do begin
   Cells[i,j]:=f(Cells[i,j]);
  end;
 end;
end;


{ *******Création de différents types de matrices et vecteurs************ }


procedure TMatrix.Zeros(RC,CC:integer);
var i,j:integer;
begin
 //forme une matrice nulle de RC lignes et CC colonne
 RowCount:=RC;ColCount:=CC;
 for i:=1 to RC do begin
  for j:=1 to CC do begin
   Cells[i,j]:=0;
  end;
 end;
end;

procedure TMatrix.Ones(RC,CC:integer);
var i,j:integer;
begin
 //forme une matrice formée de 1 de RC lignes et CC colonne
 RowCount:=RC;ColCount:=CC;
 for i:=1 to RC do begin
  for j:=1 to CC do begin
   Cells[i,j]:=1;
  end;
 end;
end;

procedure TMatrix.Eye(RC,CC:integer);
var i,j:integer;
begin
 //forme une matrice identitée de RC lignes et CC colonne
 RowCount:=RC;ColCount:=CC;
 for i:=1 to RC do begin
  for j:=1 to CC do begin
   if i=j then Cells[i,j]:=1 else Cells[i,j]:=0;
  end;
 end;
end;

procedure TMatrix.Rand(RC: Integer; CC: Integer);
var i,j:integer;
    Norm:extended;
begin
 //Forme une matrice aléatoire de RC lignes et CC colonne
 //les éléments de matrice sont compris entre -1 et +1
 RowCount:=RC;ColCount:=CC;
// randomize;
 Norm:=1/10000;
 for i:=1 to RC do begin
  for j:=1 to CC do begin
   Cells[i,j]:=Norm*(random(20000)-10000);
  end;
 end;
end;

procedure TMatrix.LinSpace(a,b:extended;n:integer);
var j:integer;
begin
 //Forme un vecteur ligne de dimension n
 //dont les valeurs forment une progression linéaire
 //entre a et b
 RowCount:=1;ColCount:=n;
 for j:=1 to n do begin
  Cells[1,j]:=a+(j-1)*(b-a)/(n-1);
 end;
end;

procedure TMatrix.SpDiags(M:TMatrix;d:integer);
var i,k,e,RC,CC:integer;
begin
  {Forme une matrice carrée de taille égale au nombre de colonne de M
  SpDiags place les lignes de M dans les diagonales de la matrice
  d est le numéro de la première diagonale à remplir
  Les autres diagonales sont mises à 0    }
 CC:=M.ColCount;RC:=M.RowCount;
 RowCount:=CC;ColCount:=CC;
 for i := 1 to CC do begin
  for k := 1 to CC do begin
   Cells[i,k]:=0;
  end;
 end;
 for k := 1 to RC do begin
  e:=d-k+2;
  if e>0 then for i := e to CC do begin
   Cells[i-e+1,i]:=M.Cells[k,i-e+1];
  end else for i := 1 to CC+e-1 do begin
   Cells[i-e+1,i]:=M.Cells[k,i];
  end;
 end;
end;

procedure TMatrix.Diags(M:TMatrix);
var j,RC:integer;
    M2:TMatrix;
begin
 //Forme un vecteur ligne de la diagonale de M
 M2:=Copy(M);
 RC:=M.RowCount;
 RowCount:=1;ColCount:=RC;
 for j := 1 to RC do begin
  Cells[1,j]:=M2.Cells[j,j];
 end;
 M2.Destroy;
end;

procedure TMatrix.ExtractMat(M:TMatrix;R1,Rn,C1,Cn:integer);
var i,j:integer;
begin
 //Extrait la matrice comprise entre les lignes R1 et Rn
 //et les colonnes C1 et Cn
 for i := R1 to Rn do begin
  for j := C1 to Cn  do begin
   Cells[i-R1+1,j-C1+1]:=M.Cells[i,j];
  end;
 end;
 RowCount:=Rn-R1+1;ColCount:=Cn-C1+1;
end;


{ **********Définition des fonctions agissant sur des matrices*********** }
{ ****************et générant de nouvelles matrices********************** }


function Transpose(M:TMatrix):TMatrix;
begin
 RESULT:=copy(M);RESULT.transpose;
end;

function Add(M1,M2:TMatrix):TMatrix;
begin
 RESULT:=copy(M1);RESULT.Add(M2);
end;

function Sub(M1,M2:TMatrix):TMatrix;
begin
 RESULT:=copy(M1);RESULT.Sub(M2);
end;

function Mul(M1,M2:TMatrix):TMatrix;
begin
 RESULT:=copy(M1);RESULT.Mul(M2);
end;

function inv(M:TMatrix):TMatrix;
begin
 RESULT:=copy(M);RESULT.Inv;
end;

function SMul(s:extended;M:TMatrix):TMatrix;
begin
 RESULT:=copy(M);RESULT.SMul(s);
end;

function ArMul(M1,M2:TMatrix):TMatrix;
begin
 RESULT:=copy(M1);RESULT.ArMul(M2);
end;

function func(M:TMatrix;f:Tfnc):TMatrix;
begin
 RESULT:=copy(M);RESULT.func(f);
end;

function Rand(RC,CC:integer):TMatrix;
begin
 RESULT:=TMatrix.create(RC,CC);RESULT.Rand(RC,CC);
end;

function Zeros(RC,CC:integer):TMatrix;
begin
 RESULT:=TMatrix.create(RC,CC);RESULT.Zeros(RC,CC);
end;

function Eye(RC,CC:integer):TMatrix;
begin
 RESULT:=TMatrix.create(RC,CC);RESULT.Eye(RC,CC);
end;

function Ones(RC,CC:integer):TMatrix;
begin
 RESULT:=TMatrix.create(RC,CC);RESULT.Ones(RC,CC);
end;

function LinSpace(a,b:extended;n:integer):TMatrix;
begin
 RESULT:=TMatrix.create(1,n);RESULT.LinSpace(a,b,n);
end;

function SpDiags(M:TMatrix;d:integer):TMatrix;
begin
 RESULT:=TMatrix.create(M.ColCount,M.ColCount);RESULT.SpDiags(M,d);
end;

function Diags(M:TMatrix):TMatrix;
begin
 RESULT:=TMatrix.create(1,M.RowCount);RESULT.Diags(M);
end;

function ExtractMat(M:TMatrix;R1,Rn,C1,Cn:integer):TMatrix;
begin
 RESULT:=TMatrix.create(Rn-R1+1,Cn-C1+1);RESULT.ExtractMat(M,R1,Rn,C1,Cn);
end;


{ *********Définition des fonctions agissant sur des matrices************ }
{ ********************et générant des scalaires************************** }


{function ln(v:extended):extended; overload;
begin
 ln:=sqr(v);
end; }

//On définit quelques fonctions qui seront utilisées par la procedure func
function sqrM(v:extended):extended;
begin
 sqrM:=sqr(v);
end;

function sqrtM(v:extended):extended;
begin
 sqrtM:=sqrt(v);
end;

function sinM(v:extended):extended;
begin
 sinM:=sin(v);
end;

function cosM(v:extended):extended;
begin
 cosM:=cos(v);
end;

function expM(v:extended):extended;
begin
 expM:=exp(v);
end;


function NormR(M:TMatrix;R:integer):extended;
var j:integer;
begin
 //calcul de la norme euclidienne de la ligne R de M
 RESULT:=0;
 for j := 1 to M.ColCount do begin
   RESULT:=RESULT+sqr(M.Cells[R,j]);
 end;
 RESULT:=sqrt(RESULT);
end;

function NormC(M:TMatrix;C:integer):extended;
var i:integer;
begin
 //Calcul de la norme euclidienne de la colonne C de M
 RESULT:=0;
 for i := 1 to M.ColCount do begin
   RESULT:=RESULT+sqr(M.Cells[i,C]);
 end;
 RESULT:=sqrt(RESULT);
end;

function ScalProdR(M1,M2:TMatrix;R1,R2:integer):extended;
var j:integer;
begin
 //Calcul du produit scalaire de la ligne R1 de M1 avec la ligne R2 de M2
 RESULT:=0;
 for j := 1 to M1.ColCount do begin
   RESULT:=RESULT+M1.Cells[R1,j]*M2.Cells[R2,j];
 end;
end;

function ScalProdC(M1,M2:TMatrix;C1,C2:integer):extended;
var i:integer;
begin
  //Calcul du produit scalaire de la colonne C1 de M1 avec la colonne C2 de M2
 RESULT:=0;
 for i := 1 to M1.RowCount do begin
   RESULT:=RESULT+M1.Cells[i,C1]*M2.Cells[i,C2];
 end;
end;

function ScalProdRC(M1,M2:TMatrix;R1,C2:integer):extended;
var i:integer;
begin
 //Calcul du produit scalaire de la ligne R1 de M1 avec la colonne C2 de M2
 RESULT:=0;
 for i := 1 to M1.ColCount do begin
   RESULT:=RESULT+M1.Cells[R1,i]*M2.Cells[i,C2];
 end;
end;

function Min(M:TMatrix):extended;
var i,j:integer;
    emin:extended;
begin
 //recherche de l'élément minimal de M
 emin:=M.Cells[1,1];
 for i := 1 to M.RowCount do begin
  for j := 1 to M.ColCount do begin
   if M.Cells[i,j]<emin then emin:=M.Cells[i,j];
  end;
 end;
 RESULT:=emin;
end;

function Max(M:TMatrix):extended;
var i,j:integer;
    emax:extended;
begin
 //recherche de l'élément maximal de M
 emax:=M.Cells[1,1];
 for i := 1 to M.RowCount do begin
  for j := 1 to M.ColCount do begin
   if M.Cells[i,j]>emax then emax:=M.Cells[i,j];
  end;
 end;
 RESULT:=emax;
end;

function SumR(M:TMatrix;R:integer):extended;
var j:integer;
begin
 //Somme des éléments présents sur la ligne R de M
 RESULT:=0;
 for j := 1 to M.ColCount do begin
   RESULT:=RESULT+M.Cells[R,j];
 end;
end;

function SumC(M:TMatrix;C:integer):extended;
var i:integer;
begin
  //Somme des éléments présents sur la colonne C de M
 RESULT:=0;
 for i := 1 to M.RowCount do begin
   RESULT:=RESULT+M.Cells[i,C];
 end;
end;

{ ******************Représentations des matrices************************* }


function MatToStr(M:TMatrix):TStringList;
var RC,CC,i,j:integer;
    Ri:string;
begin
 //Renvoit le contenu de M sous forme d'un TStringList
 RC:=M.RowCount;CC:=M.ColCount;
 RESULT:=TStringList.Create;
 for i:=1 to RC do begin
  Ri:='';
  for j:=1 to CC do begin
   Ri:=Ri+'   '+floattostr(M.Cells[i,j]);
  end;
  RESULT.Add(Ri);
 end;
end;

procedure MatToBmp(M:TMatrix;Width,Height:integer;bmp:Tbitmap;mode:integer);
var RC,CC,i,j:integer;
    Vmin,Vmax,V,Vmoy:extended;
    H,dx,dy:extended;
begin
 {Représentation graphique de la matrice M selon différents modes sur bmp
 Le dessin aura une hauteur height et une largeur width
 mode désigne le mode de réprésentation choisi:

 mode 0 et mode 1: affiche les éléments de la matrices suivant x et y
 la couleur représente alors l'amplitude de chaque élément suivant un dégradé
 de l'amplitude la plus faible (bleu) à l'amplitude la plus forte (rouge)
 Dans le mode 1, les 0 sont affichés en noir et les 1 en blanc

 mode 2:  trace les courbes correspondant aux différentes lignes, chaque ligne
 ayant une couleur différente

 mode 3: trace un histogramme avec les éléments de la première ligne            }

 RC:=M.RowCount;CC:=M.ColCount;
 bmp.Width:=Width;bmp.Height:=Height;
 Vmin:=M.Cells[1,1];
 Vmax:=Vmin;
 Vmoy:=0;
 for i:=1 to RC do begin
  for j:=1 to CC do begin
   V:=M.Cells[i,j];
   Vmoy:=Vmoy+abs(V);
   if V<Vmin then Vmin:=V;
   if V>Vmax then Vmax:=V;
  end;
 end;
  Vmoy:=Vmoy/(RC*CC);
  if mode<2 then begin
   if Vmin<>Vmax then begin
    H:=1/(Vmax-Vmin);
    dx:=(CC)/width;dy:=(RC)/height;
    for i:=0 to Width-1 do begin
     for j:=0 to Height-1 do begin
      V:=M.Cells[1+trunc(dy*j),1+trunc(dx*i)];
      if mode=1 then begin
       if abs(v/vmoy)<1E-12 then bmp.Canvas.Pixels[i,j]:=clblack     //0
       else if abs(v-1)<1E-12 then bmp.Canvas.Pixels[i,j]:=clwhite   //1
       else bmp.Canvas.Pixels[i,j]:=Col(H*(V-Vmin));
      end else bmp.Canvas.Pixels[i,j]:=Col(H*(V-Vmin));
     end;
    end;
  end else begin
   bmp.Canvas.Rectangle(0,0,width,height);
  end;
 end;
 if mode=2 then begin
  if Vmin<>Vmax then begin
   bmp.Canvas.Pen.Color:=clwhite;
   bmp.Canvas.Brush.Color:=clwhite;
   bmp.Canvas.rectangle(0,0,width,height);
   H:=1/(Vmax-Vmin);
   dx:=width/CC;dy:=height*H;
   for i := 1 to RC do begin
    bmp.Canvas.Pen.Color:=coul[i mod 10];
    V:=M.Cells[i,1]-Vmin;
    bmp.Canvas.Moveto(1,height-round(dy*V)-1);
    for j := 1 to CC do begin
     V:=M.Cells[i,j]-Vmin;
     bmp.Canvas.LineTo(trunc(dx*j),height-round(dy*V)-1);
    end;
   end;
  end;
 end;
 if mode=3 then begin
  bmp.Canvas.Pen.Color:=clwhite;
  bmp.Canvas.Brush.Color:=clwhite;
  bmp.Canvas.rectangle(0,0,width,height);
  Vmin:=M.Cells[1,1];
  Vmax:=Vmin;
  for j:=1 to CC do begin
   V:=M.Cells[1,j];
   if V<Vmin then Vmin:=V;            
   if V>Vmax then Vmax:=V;
  end;
  if Vmin>0 then Vmin:=0;
  if Vmin<>Vmax then begin
   H:=1/(Vmax-Vmin);
   dx:=width/(CC);dy:=height*H;
   bmp.Canvas.pen.color:=clblack;
   bmp.canvas.Brush.color:=clblue;
   for j := 1 to CC do begin
    V:=M.Cells[1,j]-Vmin;
    bmp.canvas.rectangle(1+trunc(dx*(j-1)),height-round(dy*V)-1,1+trunc(dx*j),height+round(dy*Vmin)-1);
   end;
   bmp.canvas.moveto(1,height+round(dy*Vmin)-1);bmp.canvas.lineto(width,height+round(dy*Vmin)-1);
  end;
 end;
end;

function col(V:extended):integer;
var c1,c2:integer;
begin
 { renvoit une couleur à partir de la valeur de V
  V doit être compris entre 0 et 1
  le bleu foncé correspond au 0 et le 1 au rouge
  le dégradé passe par les teintes bleu->vert->jaune->orange->rouge  }
 col:=0;
 if V<=1/6 then begin
  c1:=round(255*V*3);
  col:=(127+c1)*$10000;
 end;

 if (V>1/6) and (V<=3/8) then begin
  c1:=255;
  c2:=round(255*(V-1/6)*24/5);
  col:=c1*$10000+c2*$100;
 end;

 if (V>3/8) and (V<=1/2) then begin
  c1:=round(255*(V-3/8)*8);
  c2:=255;
  col:=(255-c1)*$10000+c2*$100;
 end;

 if (V>=1/2) and (V<=5/8) then begin
  c1:=round(255*(V-1/2)*8);
  c2:=255;
  col:=c1+c2*$100;
 end;

 if (V>=5/8) and (V<=5/6) then begin
  c1:=255;
  c2:=round(255*(V-5/8)*24/5);
  col:=c1+(255-c2)*$100;
 end;

 if V>=5/6 then begin
  c1:=round(255*(V-5/6)*3);
  col:=255-c1;
 end;
end;


{ ********************Décompositions de matrices************************* }


function LU(M:TMatrix):TDoubleMat;
var i,j,l,n:integer;
    V:array of extended;
    label L0,L1;
begin
 //décomposition M=L*U ou L et U sont respectivement
 //triangulaires inférieures et triangulaire supérieures
 if M.RowCount=M.ColCount then begin
  n:=M.RowCount;
  setlength(V,n+1);
  RESULT[1]:=Copy(M);
  RESULT[2]:=eye(n,n);

  for l:=1 to n-1 do begin
   for j := l+1 to n do begin
    if RESULT[1].Cells[l,l]=0 then goto L0;  //La décomposition n'existe pas
    V[j]:=-RESULT[1].Cells[l,j]/RESULT[1].Cells[l,l];
   end;

   for i:=1 to n do begin
    for j := l+1 to n do begin
     RESULT[1].Cells[i,j]:=RESULT[1].Cells[i,j]+V[j]*RESULT[1].Cells[i,l];
    end;
   end;
   for i:=1 to n do begin
    for j := l+1 to n do begin
     RESULT[2].Cells[i,l]:=RESULT[2].Cells[i,l]-V[j]*RESULT[2].Cells[i,j];
    end;
   end;
  end;
  RESULT[2]:=transpose(RESULT[2]);
  goto L1;

  L0:
   LU[1]:=nil;
   LU[2]:=nil;
  L1:
 //U.destroy;
  setlength(V,0);
 end else begin
  LU[1]:=nil;
  LU[2]:=nil;
 end;
end;

function QR(M:TMatrix):TDoubleMat;
var n,k,j2,j:integer;
    Q,R,M2:TMatrix;
    e,a,c,s:extended;
    b:array of extended;
begin
 //Décomposition M=Q*R ou Q est unitaire et R est triangulaire sup
 //La méthode de calcul dépend du type de matrice (Householder ou Givens)
 M.define;
 n:=M.RowCount;
 if M.Square then begin
  if M.Hess then begin
   //Optimisation pour les matrices de Hessenberg sup
   //On applique des matrices de rotations successivement pour éliminer les
   //éléments sous-diagonaux (Méthode de Givens)
   //Nécessite n^2 opérations
   R:=copy(M);
   Q:=eye(n,n);
   for k := 1 to n-1 do begin
    a:=R.Cells[k+1,k]/R.Cells[k,k];
    c:=1/sqrt(1+sqr(a));   //cos(theta)
    s:=a*c;                //sin(theta)
    //Ce choix de coefficients assure que la matrice Q est unitaire
    for j := k to n do begin
     e:=R.Cells[k,j];
     R.Cells[k,j]:=c*e+s*R.Cells[k+1,j];
     R.Cells[k+1,j]:=-s*e+c*R.Cells[k+1,j];     //On annule l'élément R[k+1,k]
    end;
    for j := 1 to k+1 do begin
     e:=Q.Cells[k,j];
     Q.Cells[k,j]:=c*e+s*Q.Cells[k+1,j];
     Q.Cells[k+1,j]:=-s*e+c*Q.Cells[k+1,j];     //On reporte l'opération sur la matrice Q
    end;

   end;
   RESULT[1]:=transpose(Q);
   RESULT[2]:=R;
  end else begin
   //Cas général, on applique la méthode de Householder
   //Nécéssite n^3 opérations
   R:=Zeros(n,n);
   Q:=TMatrix.create(n,n);
   M2:=transpose(M);
   setlength(b,n+1);
   e:=1/NormR(M2,1);
   R.Cells[1,1]:=1/e;
   for j := 1 to n do begin
    Q.Cells[1,j]:=e*M2.Cells[1,j];
   end;

   for k := 2 to n  do begin
    for j := 1 to n do begin
     b[j]:=M2.Cells[k,j];
    end;
    for j := 1 to k-1 do begin
     e:=0;
     for j2 := 1 to n do begin
      e:=e+Q.Cells[j,j2]*M2.Cells[k,j2];  //calcul du produit scalaire
     end;
     R.Cells[j,k]:=e;
     for j2 := 1 to n do begin
      b[j2]:=b[j2]-e*Q.Cells[j,j2];  //orthogonalisation
     end;
    end;
    e:=0;
    for j2 := 1 to n do begin
     e:=e+sqr(b[j2]);
    end;
    e:=1/sqrt(e);
    R.Cells[k,k]:=1/e;
    for j2 := 1 to n do begin
     Q.Cells[k,j2]:=e*b[j2];         //normalisation
    end;
   end;
   M2.Destroy;setlength(b,0);
   RESULT[1]:=transpose(Q);
   RESULT[2]:=R;
  end;
 end;
end;

function QL(M:TMatrix):TDoubleMat;
var n,k,j2,j:integer;
    Q,L,M2:TMatrix;
    e:extended;
    b:array of extended;
begin
 //Décomposition M=Q*L ou Q est unitaire et L est triangulaire inf
 //La méthode de calcul est celle de Householder
 M.define;
 n:=M.RowCount;
 if M.Square then begin
   //Nécéssite n^3 opérations
   L:=Zeros(n,n);
   Q:=TMatrix.create(n,n);
   M2:=transpose(M);
   setlength(b,n+1);
   e:=1/NormR(M2,n);
   L.Cells[n,n]:=1/e;
   for j := 1 to n do begin
    Q.Cells[n,j]:=e*M2.Cells[n,j];
   end;

   for k := n-1 downto 1  do begin
    for j := 1 to n do begin
     b[j]:=M2.Cells[k,j];
    end;
    for j := n downto k+1 do begin
     e:=0;
     for j2 := 1 to n do begin
      e:=e+Q.Cells[j,j2]*M2.Cells[k,j2];  //calcul du produit scalaire
     end;
     L.Cells[j,k]:=e;
     for j2 := 1 to n do begin
      b[j2]:=b[j2]-e*Q.Cells[j,j2];  //orthogonalisation
     end;
    end;
    e:=0;
    for j2 := 1 to n do begin
     e:=e+sqr(b[j2]);
    end;
    e:=1/sqrt(e);
    L.Cells[k,k]:=1/e;
    for j2 := 1 to n do begin
     Q.Cells[k,j2]:=e*b[j2];         //normalisation
    end;
   end;
   M2.Destroy;setlength(b,0);
   RESULT[1]:=transpose(Q);
   RESULT[2]:=L;
  end;
end;

function Hess(M:TMatrix):TDoubleMat;
var i,j,i2,j2,n,p:integer;
    e,max,c,s,a:extended;
    sv,cv:array of extended;
    Q,H:TMatrix;
begin
 { Méthode de réduction de Hessenberg
   On obtient M=QHQ* avec Q unitaire (Q*Q'=I) et H matrice de Hessenberg supérieure
   On utilise des matrices de rotations pour former Q }
 if M.RowCount=M.ColCount then begin
  n:=M.RowCount;
  setlength(sv,n+1);
  setlength(cv,n+1);
  n:=M.RowCount;
  Q:=eye(n,n);H:=copy(M);
  for j := 1 to n-1 do begin  //la matrice formée des j premières lignes et colonnes est une matrice de Hessenberg
   max:=(H.Cells[j+1,j]);p:=j+1;
    for i := j+2 to n do begin  //On cherche le plus grand élément max=H[p,j] dans les elements au dessous de la diagonale de la j° colonne
    if abs(H.Cells[i,j])>abs(max) then begin max:=H.Cells[i,j];p:=i; end;
   end;
   if max<>0 then begin       //si max=0, on passe à la suite
    if p<>j+1 then begin
     for i := 1 to n do begin  //On échange les lignes p et j+1
      e:=H.Cells[p,i];H.Cells[p,i]:=H.Cells[j+1,i];H.Cells[j+1,i]:=e;
      e:=Q.Cells[p,i];Q.Cells[p,i]:=Q.Cells[j+1,i];Q.Cells[j+1,i]:=e;
     end;
     for i := 1 to n do begin  //On échange les colonnes p et j+1
      e:=H.Cells[i,p];H.Cells[i,p]:=H.Cells[i,j+1];H.Cells[i,j+1]:=e;
     end;
    end;

    for i2 :=j+2 to n do begin
     a:=H.Cells[i2,j]/H.Cells[j+1,j];
     c:=1/sqrt(1+sqr(a));   //cos(theta)
     s:=a*c;                //sin(theta)
     cv[i2]:=c;sv[i2]:=s;
     for j2 := 1 to n do begin
      e:=H.Cells[j+1,j2];
      H.Cells[j+1,j2]:=c*e+s*H.Cells[i2,j2];
      H.Cells[i2,j2]:=-s*e+c*H.Cells[i2,j2];  //On annule l'élément H[i2,j]
     end;
     H.Cells[i2,j]:=0;
     for j2 := 1 to n do begin
      e:=Q.Cells[j+1,j2];
      Q.Cells[j+1,j2]:=c*e+s*Q.Cells[i2,j2];
      Q.Cells[i2,j2]:=-s*e+c*Q.Cells[i2,j2];  //On reporte les rotations sur Q
     end;
    end;
    for j2 := j+2 to n  do begin
     c:=cv[j2];s:=sv[j2];
     for i2 := 1 to n do begin
      e:=H.Cells[i2,j+1];
      H.Cells[i2,j+1]:=c*e+s*H.Cells[i2,j2];  //memes rotations sur les colonnes
      H.Cells[i2,j2]:=-s*e+c*H.Cells[i2,j2];
     end;
    end;
    //H.Cells[i2,j]:=0;
   end;
  end;
  //M=Q*H*Q'
  RESULT[1]:=transpose(Q);RESULT[2]:=H;
 // RESULT[2]._Hess:=True;
 end else begin
  RESULT[1]:=nil;RESULT[2]:=nil;
 end;
end;


{ ******************Diagonalisation de matrices************************** }


function eigvals(M:TMatrix):TMatrix;
var i,imin,jmax,j,k,n,its,itsmax,itot,nd:integer;
    QH:TDoubleMat;
    Ak:TMatrix;
    a,c,s,d,e,mu,evk,vmin,vmax,norm:extended;
    sv,cv:array of extended;
    pv:array of integer;
begin
M.define;
 if M.sym then begin
  { Méthode itérative de recherche des valeurs propres d'une matrice symétrique
  La matrice renvoyé par eigvals est une matrice diagonale contenant les valeurs
  propres de M triés par amplitude
  Algorithme:On utilise la factorisation QR avec décalages
  On pose A0=A et on effectue la liste d'opérations suivante
  Qk*Rk=Ak-u*I
  A(k+1)=Rk*Qk+u*I
  Qk n'est pas calculé explicitement
  u est le coefficient de décalage et I la matrice identité
  Ak tend vers une matrice dans laquelle les valeurs propres sont sur la diagonale
  l'algorithme nécessite en moyenne 3 itérations par valeur propre  }

  n:=M.RowCount;
  if M.Tridiag then begin
   Ak:=copy(M);
   QH[1]:=TMatrix.create(n,n); //Si M est tridiagonale on ne fait rien
  end else begin
   QH:=Hess(M);
   Ak:=QH[2];                 //Sinon on tridiagonalise M, Ak a alors les même valeurs propres que M
  end;
  norm:=0;
  for i := 1 to n do norm:=norm+sqr(Ak.Cells[i,i]);
  for i := 1 to n-1 do norm:=norm+2*sqr(Ak.Cells[i,i+1]);
  norm:=1/sqrt(norm/3);
  for i := 1 to n do begin
    for j := 1 to n do begin
     Ak.Cells[i,j]:=Ak.Cells[i,j]*norm;
    end;
  end;
  setlength(sv,n+1);
  setlength(cv,n+1);
  itsmax:=0;
  itot:=0;
  nd:=0;
  for k := n downto 2 do begin  //recherche de la k° valeur propre
   its:=0; //numéro de l'itération
   while its<=50 do begin   //On commence les itérations
    evk:=Ak.Cells[k,k];
    inc(its);
    //Le coefficient de décalage mu est celui de Wilkinson
    d:=0.5*(Ak.Cells[k-1,k-1]-Ak.Cells[k,k]);
    mu:=Ak.Cells[k,k];
    if d>0 then mu:=Ak.Cells[k,k]-sqr(Ak.Cells[k,k-1])/(d+sqrt(sqr(d)+sqr(Ak.Cells[k,k-1])));
    if d<0 then mu:=Ak.Cells[k,k]+sqr(Ak.Cells[k,k-1])/(-d+sqrt(sqr(d)+sqr(Ak.Cells[k,k-1])));
    if d=0 then mu:=Ak.Cells[k,k];
    evk:=Ak.Cells[k,k];
    for i := 1 to k do begin
     Ak.Cells[i,i]:=Ak.Cells[i,i]-mu;   //Ak=Ak-u*I
    end;

    for i := 1 to k-1 do begin    //Recherche de la k-ième valeur propre
     a:=Ak.Cells[i+1,i]/Ak.Cells[i,i];
     c:=1/sqrt(1+sqr(a));   //cos(theta)
     s:=a*c;                //sin(theta)
     cv[i]:=c;sv[i]:=s;

     if i+2<=k then jmax:=i+2 else jmax:=k;
     for j := i to jmax do begin
      e:=Ak.Cells[i,j];
      Ak.Cells[i,j]:=c*e+s*Ak.Cells[i+1,j];
      Ak.Cells[i+1,j]:=-s*e+c*Ak.Cells[i+1,j];     //On annule l'élément R[k+1,k]
     end;

    end;
    //A(k+1)=Q*(Ak-mu*I)   triang sup
    for j := 1 to k-1 do begin    //factorisation A(k+1)=Qk'*AkQk
     c:=cv[j];s:=sv[j];
     if j>1 then imin:=j-1 else imin:=1;
     for i := imin to j+1 do begin
      e:=Ak.Cells[i,j];
      Ak.Cells[i,j]:=c*e+s*Ak.Cells[i,j+1];
      Ak.Cells[i,j+1]:=-s*e+c*Ak.Cells[i,j+1];     //On effectue les mêmes rotations sur les colonnes
     end;
    end;
    for i := 1 to k do begin
     Ak.Cells[i,i]:=Ak.Cells[i,i]+mu;   //Ak=Ak-u*I
    end;
    //A(k+1)=Q'*(Ak-mu*I)*Q+mu*I=Q*Ak*Q'  tridiagonale
    if its>itsmax then itsmax:=its;
    inc(itot);
    if Ak.Cells[k,k]=evk then break;  //convergence, la valeur propre k vaut evk
   end;
   Ak.Cells[k,k-1]:=0;Ak.Cells[k-1,k]:=0;
   if its=51 then inc(nd);
  end;
  for i := 1 to n  do begin
   sv[i]:=Ak.Cells[i,i];
   cv[i]:=abs(sv[i]);      //on enregistre les amplitudes des valeurs propres
  end;

  setlength(pv,n+1);
  vmin:=cv[1];vmax:=vmin;
  for i := 1 to n do begin
   if cv[i]<vmin then vmin:=cv[i];
   if cv[i]>vmax then vmax:=cv[i];
  end;

  k:=1;
  for j := 1 to n do begin        //on tri les valeurs propres par ordre croissant
   vmin:=vmax;
   for i := 1 to n do begin
    if cv[i]<=vmin then begin
     k:=i;vmin:=cv[i];
    end;
   end;
   cv[k]:=vmax+1;
   pv[j]:=k;
  end;

  for k := 1 to n  do begin    //on classe les valeurs propres
   if pv[k]<>k then Ak.Cells[k,k]:=sv[pv[k]];
  end;

  norm:=1/norm;
  for i := 1 to n do begin
   for j := 1 to n do begin
    if i<>j then Ak.Cells[i,j]:=0 else Ak.Cells[i,j]:=Ak.Cells[i,j]*norm;
   end;
  end;

  Ak.Cells[1,0]:=nd; //nd indique le nombre de valeurs propres pour lesquelles il n'y a pas eu convergence, doit valoir 0
  Ak.Cells[2,0]:=itot; //nombre total d'itérations (pour les tests)
  Ak.Cells[3,0]:=itsmax; //nombre max d'itérations par valeur propre (pour les tests)
  RESULT:=Ak;
  QH[1].Destroy;
  setlength(cv,0);
  setlength(sv,0);
 end;
end;

function eig(M:TMatrix):TDoubleMat;
var i,imin,jmax,j,k,n,its,itsmax,itot,nd:integer;
    QH:TDoubleMat;
    Ak,Q:TMatrix;
    a,c,s,d,e,mu,evk,vmin,vmax,norm:extended;
    sv,cv:array of extended;
    pv:array of integer;
begin
 M.define;
 if M.sym then begin
  {Méthode itérative de recherche des valeurs propres et des vecteurs propres
  d'une matrice symetrique.Les valeurs propres sont triées et les vecteurs propres sont normées
  On obtient M=Q*D*Q' où Q est unitaire et D est diagonale
  Algorithme:On utilise la factorisation QR avec décalages
  On pose A0=A et on effectue la liste d'opérations suivante
  QkRk=Ak-u*I
  A(k+1)=RkQk+u*I
  ou u est le coefficient de décalage et I la matrice identité
  Ak tend vers une matrice dans laquelle les valeurs propres sont sur la diagonale
  l'algorithme nécessite en moyenne 3 itérations par valeur propre   }
  n:=M.RowCount;

  if M.Tridiag then begin
   Ak:=copy(M);
   QH[1]:=TMatrix.create(n,n); //Si M est tridiagonale on ne fait rien
  end else begin
   QH:=Hess(M);
   Ak:=QH[2];                  //sinon on tridiagonalise M, Ak a alors les même valeurs propres que M
  end;
  norm:=0;
  for i := 1 to n do norm:=norm+sqr(Ak.Cells[i,i]);
  for i := 1 to n-1 do norm:=norm+2*sqr(Ak.Cells[i,i+1]);
  norm:=1/sqrt(norm/3);
  for i := 1 to n do begin
    for j := 1 to n do begin
     Ak.Cells[i,j]:=Ak.Cells[i,j]*norm;
    end;
   end;
  setlength(sv,n+1);
  setlength(cv,n+1);
  Q:=eye(n,n);
  itsmax:=0;
  itot:=0;
  nd:=0;
  for k := n downto 2 do begin  //recherche de la k° valeur propre
   its:=0;                 //numéro de l'itération
   while its<=50 do begin  //On commence les itérations
    evk:=Ak.Cells[k,k];
    inc(its);
    d:=0.5*(Ak.Cells[k-1,k-1]-Ak.Cells[k,k]);
    mu:=Ak.Cells[k,k];
    if d>0 then mu:=Ak.Cells[k,k]-sqr(Ak.Cells[k,k-1])/(d+sqrt(sqr(d)+sqr(Ak.Cells[k,k-1])));
    if d<0 then mu:=Ak.Cells[k,k]+sqr(Ak.Cells[k,k-1])/(-d+sqrt(sqr(d)+sqr(Ak.Cells[k,k-1])));
    if d=0 then mu:=Ak.Cells[k,k];
                                //mu est le coefficient de décalage de Wilkinson
    evk:=Ak.Cells[k,k];
    for i := 1 to k do begin
     Ak.Cells[i,i]:=Ak.Cells[i,i]-mu;   //Ak=Ak-u*I
    end;

    for i := 1 to k-1 do begin //factorisation A(k+1)=Qk'*Ak*Qk
     a:=Ak.Cells[i+1,i]/Ak.Cells[i,i];
     c:=1/sqrt(1+sqr(a));      //cos(theta)
     s:=a*c;                   //sin(theta)
     cv[i]:=c;sv[i]:=s;        //On effectue une rotation élémentaire d'angle theta
                               //Ce choix de coefficients assure que la matrice Q est unitaire
     if i+2<=k then jmax:=i+2 else jmax:=k;
     for j := i to jmax do begin
      e:=Ak.Cells[i,j];
      Ak.Cells[i,j]:=c*e+s*Ak.Cells[i+1,j];
      Ak.Cells[i+1,j]:=-s*e+c*Ak.Cells[i+1,j];     //On annule l'élément Ak[k+1,k]
     end;

     for j := 1 to n do begin
      e:=Q.Cells[i,j];
      Q.Cells[i,j]:=c*e+s*Q.Cells[i+1,j];
      Q.Cells[i+1,j]:=-s*e+c*Q.Cells[i+1,j];     //On reporte l'opération sur la matrice Q
     end;

    end;

    for j := 1 to k-1 do begin    //factorisation A(k+1)=Qk*AkQk
     c:=cv[j];s:=sv[j];
     if j>1 then imin:=j-1 else imin:=1;
     for i := imin to j+1 do begin
      e:=Ak.Cells[i,j];
      Ak.Cells[i,j]:=c*e+s*Ak.Cells[i,j+1];
      Ak.Cells[i,j+1]:=-s*e+c*Ak.Cells[i,j+1];     //On effectue les mêmes rotations sur les colonnes
     end;
    end;
    for i := 1 to k do begin
     Ak.Cells[i,i]:=Ak.Cells[i,i]+mu;   //Ak=Ak-u*I
    end;
                                      //A(k+1)=Q'*(Ak-mu*I)*Q+mu*I=Q*Ak*Q'  tridiagonale
    if its>itsmax then itsmax:=its;
    inc(itot);
  //  if (abs(Ak.Cells[k-1,k]/Ak.Cells[k,k])<1E-13) and (abs(Ak.Cells[k,k-1]/Ak.Cells[k,k])<1E-13) then break;
    if evk=Ak.Cells[k,k] then break;  //on a trouvé la k-ième valeur propre
   end;
   Ak.Cells[k,k-1]:=0;Ak.Cells[k-1,k]:=0;
   if its=51 then inc(nd);          //l'algorithme ne converge pas
  end;

  if M.Tridiag then Q.transpose else begin
   Q.transpose;
   Q.LMul(QH[1]);
  end;
  //les colonnes de Q contiennent les vecteurs propres de Ak
  for i := 1 to n  do begin
   sv[i]:=Ak.Cells[i,i];
   cv[i]:=abs(sv[i]);      //on enregistre les amplitudes des valeurs propres
  end;

  setlength(pv,n+1);
  vmin:=cv[1];vmax:=vmin;
  for i := 1 to n do begin
   if cv[i]<vmin then vmin:=cv[i];
   if cv[i]>vmax then vmax:=cv[i];
  end;
  k:=1;
  for j := 1 to n do begin        //on tri les valeurs propres par ordre croissant
   vmin:=vmax;
   for i := 1 to n do begin
    if cv[i]<=vmin then begin
     k:=i;vmin:=cv[i];
    end;
   end;
   cv[k]:=vmax+1;
   pv[j]:=k;
  end;

  QH[1].Destroy;
  QH[1]:=copy(Q);

  for k := 1 to n  do begin    //on classe les valeurs propres et les vecteurs propres normés
   if pv[k]<>k then begin
    for i := 1 to n  do begin
     Q.Cells[i,k]:=QH[1].Cells[i,pv[k]];
    end;
    Ak.Cells[k,k]:=sv[pv[k]];
   end;
  end;

  norm:=1/norm;
  for i := 1 to n do begin
   for j := 1 to n do begin
    if i<>j then Ak.Cells[i,j]:=0 else Ak.Cells[i,j]:=Ak.Cells[i,j]*norm;
   end;
  end;

  Ak.Cells[1,0]:=nd; //nd indique le nombre de valeurs propres pour lesquelles il n'y a pas eu convergence, doit valoir 0
  Ak.Cells[2,0]:=itot; //nombre total d'itérations (pour les tests)
  Ak.Cells[3,0]:=itsmax; //nombre max d'itérations par valeur propre (pour les tests)
  RESULT[1]:=Q;
  RESULT[2]:=Ak;
  QH[1].Destroy;
  setlength(cv,0);
  setlength(sv,0);
 end;
end;

function Schur(M:TMatrix):TDoubleMat;
begin
 //Décomposition de Schur
 M.define;
 if M.Square then begin
  if M.Sym then begin
   RESULT:=eig(M);
  end;
 end;
end;

end.
