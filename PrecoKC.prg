#Include "Minigui.ch"
#Include "Common.ch"
#Define COR {255,215,227}
#Define COR2 {255,234,241}
*----------------------*
Procedure controle_prc
*----------------------*
SET DATE BRITISH	
SET CENTURY ON   

REQUEST DBFCDX 
RDDSETDEFAULT("DBFCDX")
DBSETDRIVER("DBFCDX")

Public DRIVER := "DBFCDX"
Public nCustot
Public nPrcvend		
Public nLucro		
Public nPortec		
Public nTeclas	
Public nMptotal		
Public Struct := {}	
Public CdxBase := "BaseKc"	
Public BaseKc := "BaseKc.DBF"	

If Select('BaseKc') = 0 .and. ! BaseKcOpen()
   Return
Endif

	DEFINE WINDOW winpreco; 
	AT 0,0;							
	WIDTH 725 HEIGHT 520;
	TITLE 'Controle de preço de Keycaps';
	MAIN;
	NOMAXIMIZE;
	NOSIZE;
	BACKCOLOR COR
		@10, 300 Label cGrid;
		VALUE 'Lista de Orçamentos';
		WIDTH 400 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@30, 10 GRID regiStrogrid;
		WIDTH 700 HEIGHT 330;
		HEADERS {'Custos de Prod.',;
				'Lucro%',;
				'Preço para Venda',;
				'Núm. de Teclas','Preço por Tecla',;
				'Horário','Data'};
		WIDTHS {115,85,115,100,100,85,100};	
		JUSTIFY{BROWSE_JTFY_LEFT,;
				BROWSE_JTFY_CENTER,;
				BROWSE_JTFY_LEFT,;
				BROWSE_JTFY_CENTER, BROWSE_JTFY_LEFT,;
				BROWSE_JTFY_CENTER, BROWSE_JTFY_CENTER};
				BACKCOLOR COR2
		@375, 23 BUTTON orckc;	
		CAPTION 'Novo Orçamento';
		WIDTH 150;	
		ACTION { ||mpcust() }
		@425,23 BUTTON lista;
		CAPTION 'Listagem';
		ACTION { ||listagem() };
		TOOLTIP 'Lista de orçamentos para .txt' 	
		@375, 225 FRAME period1;
		CAPTION 'Pesquisar período de ';
		WIDTH 300 HEIGHT 75;
		BACKCOLOR COR;
		TRANSPARENT
		@410, 375 Label period2;
		VALUE 'à';
		BACKCOLOR COR
		@405, 245 DATEPICKER dInicio;
		ON ENTER { ||porData() } 
		@405, 395 DATEPICKER dFinal;
		ON ENTER { ||porData() }
		@375, 595 BUTTON pesquisar;
		CAPTION 'Pesquisar';
		WIDTH 100;
		ACTION{ ||porData() }
		@425, 595 BUTTON sairprograma;
		CAPTION 'Sair';
		WIDTH 100;
		ACTION { ||winpreco.release } 	
			DEFINE STATUSBAR FONT 'Arial' SIZE 8
				STATUSITEM "Versão 2.3" WIDTH 300
				CLOCK 
				DATE
			END STATUSBAR
	END WINDOW	
	CENTER WINDOW winpreco	
	ACTIVATE WINDOW winpreco	
Return
*----------------------*
Function listagem()
*----------------------*
List custo , venda , lucro , por_tecla , num_tecla , " 	  " , hora , "  	 " , data To File lista.txt
execute File("lista.txt")
Return Nil
*----------------------*
Procedure mpcust()	//função para janela de entrada de dados da matéria-prima
*----------------------*
	DEFINE WINDOW mpwin;
	AT 0,0;
	WIDTH 600 HEIGHT 400;
	TITLE 'Custo da Matéria-Prima';
	CHILD;
	NOMAXIMIZE;
	NOSIZE;
	BACKCOLOR COR
		@ 25,0100 Label digite1;	
		VALUE 'Resina:';	
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 40,125 Label  rs1;
			VALUE 'R$';
			BACKCOLOR COR
		@ 65,0100 Label  digite2;
		VALUE 'Papel adesivo:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 80,125 Label  rs2;
			VALUE 'R$';
			BACKCOLOR COR
		@ 105,100 Label  digite3;
		VALUE 'Adesivo:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 120,125 Label  rs3;
			VALUE 'R$';
			BACKCOLOR COR
		@ 145,100 Label  digite4;
		VALUE 'Glitter:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 160,125 Label  rs4;
			VALUE 'R$';
			BACKCOLOR COR
		@ 185,100 Label  digite5;
		VALUE 'Corante líq.:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 200,125 Label  rs5;
			VALUE 'R$';
			BACKCOLOR COR
		@ 225,100 Label  digite6;
		VALUE 'Corante pó:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 240,125 Label  rs6;
			VALUE 'R$';
			BACKCOLOR COR
				@40, 150 TEXTBOX mp1 WIDTH 100;	
				RIGHTALIGN;
					ON ENTER mpwin.mp2.setfocus 
				@80, 150 TEXTBOX mp2 WIDTH 100;
				RIGHTALIGN;
					ON ENTER mpwin.mp3.setfocus
				@120, 150 TEXTBOX mp3 WIDTH 100;
				RIGHTALIGN;
					ON ENTER mpwin.mp4.setfocus
				@160, 150 TEXTBOX mp4 WIDTH 100;
				RIGHTALIGN;
					ON ENTER mpwin.mp5.setfocus
				@200, 150 TEXTBOX mp5 WIDTH 100;
				RIGHTALIGN;
					ON ENTER mpwin.mp6.setfocus
				@240, 150 TEXTBOX mp6 WIDTH 100;
				RIGHTALIGN;
					ON ENTER mpwin.calcmprc.setfocus
		@90, 300 BUTTON calcmprc;
		CAPTION 'Calcular Matéria-Prima';
		WIDTH 200;
		ACTION { ||calculamp(),custoprod(),mpwin.release };
		TOOLTIP 'Calcula e passa para Custo de Produção' 
		@120, 300 BUTTON calcmpsai;
		CAPTION 'Voltar';
		ACTION { ||mpwin.release }
	END WINDOW
	CENTER WINDOW mpwin
	ACTIVATE WINDOW mpwin
Return
*----------------------*
Function calculamp()	// função para calcular materia prima
*----------------------*
Local mp1 := Val(mpwin.mp1.value)	
Local mp2 := Val(mpwin.mp2.value)
Local mp3 := Val(mpwin.mp3.value)
Local mp4 := Val(mpwin.mp4.value)
Local mp5 := Val(mpwin.mp5.value)
Local mp6 := Val(mpwin.mp6.value)
	nMptotal := mp1 + mp2 + mp3 + mp4 + mp5 + mp6	
Return Nil
*----------------------*
Procedure custoprod()	// função para janela de entrada para custo de produção 	
*----------------------*
	DEFINE WINDOW cwin;
	AT 0,0;
	WIDTH 500 HEIGHT 400;
	TITLE 'Custo de Produção';
	CHILD;
	NOMAXIMIZE;
	NOSIZE;
	BACKCOLOR COR
		@ 25,0100 Label digite1;
		VALUE 'Valor da Matéria-Prima:';
		WIDTH 150 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@ 65,0100 Label  digite2;
		VALUE 'Valor da Mão de Obra:';
		WIDTH 150 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 40,100 Label  digite3;
			VALUE 'R$';
			WIDTH 50 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
			BACKCOLOR COR
			@ 80,100 Label  digite4;
			VALUE 'R$';
			WIDTH 50 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
			BACKCOLOR COR
				@40, 150 TEXTBOX materiaprima WIDTH 100;
				RIGHTALIGN;
					ON ENTER cwin.maodeobra.setfocus
						cwin.materiaprima.value := Alltrim(Str(nMptotal,10,2))
				@80, 150 TEXTBOX maodeobra WIDTH 100;
				RIGHTALIGN;
					ON ENTER cwin.calcust.setfocus
			@90, 275 BUTTON calcust;
			CAPTION 'Calcular Custo';
			WIDTH 100;
			ACTION {||custocalc(), precovend(), cwin.Release};
			TOOLTIP 'Calcula e passa para preço para venda'
			@120, 275 BUTTON custsai;
			CAPTION 'Sair';
			ACTION { ||cwin.Release}
	END WINDOW
	CENTER WINDOW cwin
	ACTIVATE WINDOW cwin
Return
*----------------------*
Function custocalc()	//calcula o custo de produção
*----------------------*
Local nMaodeobra := Val(cwin.maodeobra.value)	
Local nMateriaprima := Val(cwin.materiaprima.value)
	nCustot := nMateriaprima + nMaodeobra	
Return Nil
*----------------------*
Procedure precovend()	// janela para entradas do preço de venda
*----------------------*
LOCAL custotval
	DEFINE WINDOW vwin;
	AT 0,0;
	WIDTH 500 HEIGHT 400;
	TITLE 'Preço para Venda';
	CHILD;
	NOMAXIMIZE;
	NOSIZE;
	BACKCOLOR COR
		@ 25,0100 Label digite1;
		VALUE 'Valor do Custo de Produção:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@ 65,0100 Label  digite2;
		VALUE 'Valor do Lucro Pretendido:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@ 0105,0100 Label Resultado;
		VALUE 'Preço para Venda:';
		WIDTH 150 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@ 40,100 Label  digite3;
		VALUE 'R$';
		WIDTH 50 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@ 80,220 Label  digite4;
		VALUE '%';
		WIDTH 35 HEIGHT 25 FONT 'Arial' SIZE 10 BOLD;
		BACKCOLOR COR
		@ 120,100 Label  digite5;
		VALUE 'R$';
		WIDTH 50 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR	
		@40, 150 TEXTBOX custodeproducao WIDTH 100;
		RIGHTALIGN;
			ON ENTER vwin.lucroporc.setfocus
		@80, 150 TEXTBOX lucroporc WIDTH 70;
		RIGHTALIGN;
			ON ENTER vwin.calcvend.setfocus
		@120,150 TEXTBOX precovenda WIDTH 100;	
		READONLY BACKCOLOR COR2
			vwin.custodeproducao.value:= Alltrim(Str(nCustot,10,2))
		@60,275 BUTTON calcvend;
		CAPTION 'Calcular';
		ACTION{ ||vendcalc() }
		TOOLTIP 'Calcula e moStra o Preço Total'
		@90, 275 BUTTON grava;
		CAPTION 'Calcular preço por Tecla';
		WIDTH 200;
		ACTION { ||vendcalc(),valtecla(), vwin.release };
		TOOLTIP 'Calcula e passa para Preço Total por Tecla'
		@120, 275 BUTTON vendsai;
		CAPTION 'Sair';
		ACTION { ||vwin.Release }
	END WINDOW
	CENTER WINDOW vwin
	ACTIVATE WINDOW vwin
Return
*----------------------*
Function vendcalc()		//calcula o custo de produção
*----------------------*
Local nCustoprod := Val(vwin.custodeproducao.value)	
Local nValucrporc := Val(vwin.lucroporc.value) / 100	
Local nValucr := nValucrporc * nCustoprod	
	nPrcvend := nValucr + nCustoprod	
	nLucro := Val(vwin.lucroporc.value)
	vwin.precovenda.value := Alltrim(Str(nPrcvend,10,2))
Return Nil
*----------------------*
Procedure valtecla()	// janela para entrada do valor de venda por tecla 
*----------------------*
	DEFINE WINDOW wintec;
	AT 0,0;
	WIDTH 500 HEIGHT 400;
	TITLE 'Preço por Tecla';
	CHILD;
	NOMAXIMIZE;
	NOSIZE;
	BACKCOLOR COR
		@ 25,0100 Label digite1;
		VALUE 'Valor Total para Venda:';
		WIDTH 200 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@ 65,0100 Label  digite2;
		VALUE 'Número de Teclas:';
		WIDTH 150 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
		@ 0105,0100 Label Resultado;
		VALUE 'Preço por Tecla:';
		WIDTH 150 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
		BACKCOLOR COR
			@ 40,100 Label  dig1;
			VALUE 'R$';
			WIDTH 50 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
			BACKCOLOR COR
			@ 120,100 Label  dig2;
			VALUE 'R$';
			WIDTH 50 HEIGHT 25 FONT 'Arial' SIZE 09 BOLD;
			BACKCOLOR COR	
				@40, 150 TEXTBOX totalvenda WIDTH 100;
				RIGHTALIGN;
					ON ENTER wintec.portec.setfocus
	wintec.totalvenda.value := Alltrim(Str(nPrcvend,10,2))
				@80, 150 TEXTBOX portec WIDTH 100;
				RIGHTALIGN;
					ON ENTER wintec.calculatec.setfocus
				@120, 150 TEXTBOX resultec WIDTH 100;
				READONLY BACKCOLOR COR2	
			@60, 275 BUTTON calculatec;
			CAPTION 'Calcular';
			ACTION { ||calcportec() }
			@90, 275 BUTTON gravatec;
			CAPTION 'Gravar e Sair';
			ACTION { ||calcportec(),gravacalc(),sucesso(),wintec.Release };
			TOOLTIP 'Calcula e regiStra o preço total e individual'
			@120, 275 BUTTON tecsai;
			CAPTION 'Sair sem gravar';
			ACTION { ||wintec.Release }
	END WINDOW
	CENTER WINDOW wintec
	ACTIVATE WINDOW wintec
Return
*----------------------*
Function calcportec()	// função para calcular o preço de venda por tecla
*----------------------*
	nTeclas := Val(wintec.portec.value)	
	nPortec := nPrcvend / nteclas
	wintec.resultec.value := Alltrim(Str(nPortec,10,2))
Return Nil
*----------------------*
Function sucesso()
*----------------------*
	msginfo('O Orçamento foi salvo no Registro!')
Return Nil
*----------------------*
Function gravacalc()	// função para armazenar os dados dos calculos feitos 
*----------------------*
Local cHora := Time()
Local dData := Date()
	BaseKc->(OrdSetFocus(1))
	BaseKc->(DbAppend())
		BaseKc->custo := nCustot	 
		BaseKc->venda := nPrcvend
		BaseKc->lucro := nLucro
		BaseKc->por_tecla := nPortec
		BaseKc->num_tecla := nTeclas
		BaseKc->hora := cHora
		BaseKc->Data := dData
Return Nil
*----------------------*
Function BaseKcOpen()
*----------------------*
	If .NOT. File (BaseKc)	
		aadd(Struct,{'custo' ,'N' , 19, 4 })	
		aadd(Struct,{'lucro' , 'N' , 19, 4 })	
		aadd(Struct,{'venda' ,'N' , 19, 4 })
		aadd(Struct,{'num_tecla' ,'N' , 19, 4 })
		aadd(Struct,{'por_tecla' ,'N' , 19, 4 })
		aadd(Struct,{'hora', 'C' , 8, 0 })				
		aadd(Struct,{'Data' , 'D', 8 , 0 })
			DbCreate(BaseKc, Struct, DRIVER)	
	Endif
USE (BaseKc) ALIAS BaseKc New Shared Via DRIVER 
   If NetErr()
      MsgSTOP("Atenção ! Arquivo de [  ] está bloqueado.")
      Return(.F.)
   Endif
	If ! File (Cdxbase+".cdx")
	Index on Descend(Dtos(Data)) + Descend(hora) Tag tempo to (Cdxbase)
	Endif 	
BaseKc->(DbSetIndex((Cdxbase)))	
Return(.T.)
*----------------------*
Function porData()	// função para pesquisa por Data 
*----------------------*
Local Data1 
Local Data2 
Data1 := winpreco.dInicio.value 
Data2 := winpreco.dFinal.value
winpreco.regiStrogrid.deleteallitems	
BaseKc->(OrdSetFocus(1))	
BaseKc->(DbSeek(DtoS(Data2),.T.))
Do While ! BaseKc->Data < Data1 .and. ! BaseKc->(Eof()) 
   If BaseKc->Data > Data2	
      BaseKc->(DbSkip())	
      Loop
   Endif
	ADD ITEM{Alltrim("R$"+(Str(BaseKc->custo,10,2))),;	
			Alltrim(Str(BaseKc->lucro,10,2)+"%"),;	
			Alltrim("R$"+(Str(BaseKc->venda,10,2))),;	
			Alltrim(Str(BaseKc->num_tecla,10,0)),;	
			Alltrim("R$"+(Str(BaseKc->por_tecla,10,2))),;
			Alltrim(BaseKc->hora,8,0),;	
			DtoC(BaseKc->Data)}to regiStrogrid of winpreco
	BaseKc->(DbSkip())	
Enddo
Return 
