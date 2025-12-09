#!/usr/bin/perl 
use strict;
use warnings;
no warnings 'uninitialized';
use Tk;
use Tk::BrowseEntry;
use Tk::ROText;
use Tk::Stderr;
use Tk::Checkbox;
use Encode::Unicode;
#use POSIX;
use POSIX 'acos'; 
use POSIX 'fmod';
use File::HomeDir;
use File::Basename;
use Win32;
use Math::Random::MT;


use Scalar::Util 'looks_like_number';

#stamp package:
use Cwd;
my $dir = getcwd;
my $user = getlogin();
#my @userData = getpwnam($user);
#my $hd = $#userData - 1;
my @timeData = split(" ", localtime(time));
my $timeString = join(" ", @timeData);
#my $shell = $#userData;
my $progLoc = $0;
my $command = join(" ", @ARGV);
my $sys = $^O;

my $home  = File::HomeDir->my_home;
my($filename, $directories, $suffix) = fileparse($home);
my @sep = split ("", $directories);
while (($sep[0] ne '/') && ($sep[0] ne '\\'))
	{
		shift(@sep);
	}
my $seps = $sep[0];

my $quit = 0;
our $resultsOut;
our %densityFrequencyHash;
our @tempFileList;
my $genomeBaseCount = 0;


my $mw = MainWindow -> new;#->InitStderr;
$mw ->maxsize(820,650);
$mw ->minsize(820,650);
$mw ->title("PeaKDEck v1.1");

#$mw->optionAdd('*font', 'Arial 10');

my $pixmap_data = <<'end-of-x11-pixmap-data';
/* XPM */
static char *_0130917peaKDEck_logo_back33px[] = {
/* columns rows colors chars-per-pixel */
"33 33 231 2 ",
"   c #7E2C4B",
".  c #78365A",
"X  c #78406A",
"o  c #75567C",
"O  c #B81A1F",
"+  c #9F1B26",
"@  c #A31E2F",
"#  c #AE182D",
"$  c #B61725",
"%  c #BB1B21",
"&  c #AE242B",
"*  c #BC202C",
"=  c #BC3628",
"-  c #AD2C33",
";  c #B6383D",
":  c #CB0B0F",
">  c #D3040D",
",  c #C61A0E",
"<  c #D80C19",
"1  c #C7141C",
"2  c #CA2412",
"3  c #CE2C13",
"4  c #D22B16",
"5  c #C93517",
"6  c #CB1424",
"7  c #C31C30",
"8  c #BE5116",
"9  c #AE422B",
"0  c #BC5436",
"q  c #CA431A",
"w  c #D15F19",
"e  c #D6651B",
"r  c #DB7E1D",
"t  c #C64C2F",
"y  c #FF7B20",
"u  c #842846",
"i  c #853049",
"p  c #91345A",
"a  c #B32F43",
"s  c #9C4249",
"d  c #A7444A",
"f  c #B4424F",
"g  c #A14F59",
"h  c #B34954",
"j  c #87526B",
"k  c #A85C65",
"l  c #99676E",
"z  c #8E6270",
"x  c #976276",
"c  c #9C757E",
"v  c #A6636D",
"b  c #A76975",
"n  c #AB737D",
"m  c #CA7C5B",
"M  c #449E0B",
"N  c #479A16",
"B  c #45A606",
"V  c #44AA00",
"C  c #46A40B",
"Z  c #48A60D",
"A  c #49A414",
"S  c #4CA319",
"D  c #4B9525",
"F  c #529736",
"G  c #4FA423",
"H  c #50A625",
"J  c #53A52B",
"K  c #59A73C",
"L  c #59A838",
"P  c #378057",
"I  c #3B8F75",
"U  c #5EA946",
"Y  c #5DA148",
"T  c #62AC4D",
"R  c #65AD52",
"E  c #65A25C",
"W  c #69AD5D",
"Q  c #579C66",
"!  c #6AAE64",
"~  c #6DAC6A",
"^  c #6DB265",
"/  c #61A478",
"(  c #73B473",
")  c #77B57A",
"_  c #7AB87E",
"`  c #D6861C",
"'  c #D48E26",
"]  c #FF8621",
"[  c #EC9620",
"{  c #FF9322",
"}  c #FF9A22",
"|  c #E8A322",
" . c #FFA423",
".. c #FFA923",
"X. c #EDB722",
"o. c #FEB324",
"O. c #F3B923",
"+. c #EBBE33",
"@. c #FFC425",
"#. c #FFCA26",
"$. c #EDC63A",
"%. c #FAD133",
"&. c #B58849",
"*. c #D28C52",
"=. c #FCA85B",
"-. c #F2D345",
";. c #EAD55B",
":. c #DDD77A",
">. c #EECC6F",
",. c #E2D76D",
"<. c #E2D86D",
"1. c #555796",
"2. c #6D4F84",
"3. c #605F98",
"4. c #766A82",
"5. c #5E63A3",
"6. c #5977B7",
"7. c #636AA0",
"8. c #3372C4",
"9. c #316ED7",
"0. c #0D5DEE",
"q. c #0D54F0",
"w. c #175DF0",
"e. c #0D64EC",
"r. c #0B6DE9",
"t. c #0C74E6",
"y. c #0A7CE4",
"u. c #317BEC",
"i. c #5379C3",
"p. c #836E89",
"a. c #977982",
"s. c #A17D86",
"d. c #AB7D8C",
"f. c #7BB784",
"g. c #7DB889",
"h. c #6FA59B",
"j. c #7FB391",
"k. c #4A88B3",
"l. c #678EA8",
"z. c #6A9FA4",
"x. c #719CB6",
"c. c #1F88D1",
"v. c #0893DE",
"b. c #069BDC",
"n. c #1B93D1",
"m. c #3E97C7",
"M. c #06A4D9",
"N. c #05ABD8",
"B. c #13A2DC",
"V. c #08B4D6",
"C. c #2BACDE",
"Z. c #0983E3",
"A. c #088BE0",
"S. c #2389EE",
"D. c #3CA2E8",
"F. c #4F91CB",
"G. c #518ADC",
"H. c #4996D1",
"J. c #658DC0",
"K. c #6A93C3",
"L. c #6694CB",
"P. c #6295D1",
"I. c #749FD6",
"U. c #46B9DF",
"Y. c #53B1DA",
"T. c #73A3D9",
"R. c #4C8DE5",
"E. c #4A8EE8",
"W. c #548EED",
"Q. c #4F9CEA",
"!. c #5797E8",
"~. c #619EE8",
"^. c #47A3E6",
"/. c #58B4E3",
"(. c #63A3E8",
"). c #71ACE8",
"_. c #62BDE3",
"`. c #75B1EA",
"'. c #2FC0D9",
"]. c #56CCDD",
"[. c #71C5E4",
"{. c #9C8A93",
"}. c #97909A",
"|. c #AD8986",
" X c #AD938C",
".X c #A08B94",
"XX c #A58C98",
"oX c #80BB8F",
"OX c #87BE9C",
"+X c #B7B081",
"@X c #848AA8",
"#X c #9E9AA3",
"$X c #83A5AB",
"%X c #9EA8B2",
"&X c #8CBFB8",
"*X c #A4A3AD",
"=X c #A3AAB5",
"-X c #A5B3BF",
";X c #8BC1A4",
":X c #8FC3AD",
">X c #93C6B5",
",X c #98CABD",
"<X c #D8D985",
"1X c #D0DB99",
"2X c #FDC288",
"3X c #F9CD92",
"4X c #CCD2AA",
"5X c #D8D1AF",
"6X c #CFD3B4",
"7X c #FFDEA9",
"8X c #EBD5B9",
"9X c #FEE1BB",
"0X c #96A5C1",
"qX c #9CB0C3",
"wX c #9FBAC5",
"eX c #A5B9C4",
"rX c #9FCFCE",
"tX c #86CAD0",
"yX c #A0D0CC",
"uX c #A4C4D1",
"iX c #A7C9D5",
"pX c #A3D2D3",
"aX c #A9D1DC",
"sX c #B8DCD3",
"dX c #8AC0EA",
"fX c #98CBE9",
"gX c #9AD1E8",
"hX c #A5D4E3",
"jX c #AFDDE9",
"kX c #B2DDE2",
"lX c #FFE4C1",
/* pixels */
"jXjXjXjXjXjXjXjXjXjXjXkX4X<.-.%.;.<X|.d.eXjXjXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXkX,.#.#.@.@.@.@.4 ; 7 n jXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXkX-.#.@.o.o.o.o.| < X.+X1 kXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXkX:.@.O.o... . . .e 4 @.' 6 jXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXsX#.@.[ r } { { { 5 = r q t jXjXeXuXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjX1X#.O.3 w { ] ] *.7.X a q +.jX*X6 ; aXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjX,.| o.4 w { y m W.0X8XI.L.$. X< v v f jXjXjXjXjXjX",
"jXjXjXjXjXjXjXjX,.q 5 3 : 2 = 5.@X2XlX3XP.2.6 b 7 eXk =XjXjXjXjXjX",
"jXjXjXjXjXjXjXjX1XO.3 > 8 0 p p.=.3X7X7X>.7.# qXXXg jXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjX|.5 ` 3 = G.J.l.K.9X4X5X6XS.1.# uX=Xh v aXjXjXjXjX",
"jXjXjXjXjXjXjX%X; 9 , &.i 8.S.F.S.x.S.S.S.^.S.1.6.* s.v n jXuXjXjX",
"jXjXjXjXkX*Xv }.a.s 9 u F.l.k.Z.l.S.z.h.H.B.C.D.i.@ wX=X{..X# iXjX",
"jX-Xk |.uX- l - a.$   $Xl.t.y.y.c.h.n.v.b.b.b.M._.2.@ %Xs.$ #XjXjX",
"l & b 1 }.O s z o 6.E.r.t.t.y.y.Z.Z.A.v.b.b.N.N.N._.R.j > O - #XjX",
"k d =X% %Xc + u i.u.e.r.r.t.y.y.Z.A.A.v.b.b.M.N.N.V.Y.. 4.- eXwXjX",
"iX% O .XfX!.R.!.w.e.e.r.r.t.y.y.Z.Z.v.v.b.b.M.N.N.V.V./.X x jXjXjX",
"jX.X% T.E.~.W.q.0.0.e.r.r.t.y.Z.Z.Z.A.v.b.b.M.N.N.V.'.].K.6.gXjXjX",
"jXgXi 3./ Q 9.w.0.0.e.r.t.t.t.Z.Z.A.v.v.b.C.U.[.tX) ( _ &X(.(.jXjX",
"jXgX).&XV V S f.gXdX`.(.Q.I P m.^./.[.gXjXjXjXjXU V V V A pXhXjXjX",
"jXjXjXpXH V V V K rXjXjXf.K hXY &XjXjXjXOX( OXjXS V N V S hXjXjXjX",
"jXjXjXjXpXW B V B G >XjX:Xj.jX:XZ ( jX,XV V N J F V E ) ,XjXjXjXjX",
"jXjXjXjXjXjX;XJ V V S ;XjX! g.jX~ V L j.V Z ~ B Z V _ jXjXjXjXjXjX",
"jXjXjXjXjXjXjXpXK V V V j.pXH W rXJ V Z D J j.S V V ;XjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXR V V B g.OXB J E V V G Y V Y ^ oXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXW V V Z >XU V C D B V S V T jXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjX! V V J :XB V J ) C V V ( jXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjXjXY V V R W V V >XrXf.OXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjXjXrXH V V E V V f.jXjXjXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjXjXjX:XC V Z M B R jXjXjXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjXjXjXjX( V V F B G jXjXjXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjXjXjXjXjXL V B V M jXjXjXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjXjXjXjXjX,XZ V V U jXjXjXjXjXjXjXjXjXjXjXjXjX",
"jXjXjXjXjXjXjXjXjXjXjXjXjXjXjXjX:XT ^ yXkXjXjXjXjXjXjXjXjXjXjXjXjX"
};

end-of-x11-pixmap-data

$mw->Icon(-image => $mw->Pixmap(-data => $pixmap_data));

my $frameSetUp = $mw -> Frame() 
		-> pack(
			-side => 'top',
			-fill => "none",
			-anchor => 'w',
			-expand => 0);

my $frameKeyRunSetUp = $frameSetUp -> Frame (-borderwidth => 2, -relief => 'groove')
	-> pack(
			
			#-ipadx => 300,
			-side => 'left',
			-anchor => 'w',
			-fill => "none",
			-expand => 0);

my $frameKeyRunSetUpLeft = $frameKeyRunSetUp -> Frame ()
	-> pack(
			
			#-ipadx => 300,
			-side => 'left',
			-anchor => 'w',
			-fill => "none",
			-expand => 0);

my $frameKeyRunSetUpRight = $frameKeyRunSetUp -> Frame ()
	-> pack(
			
			#-ipadx => 300,
			-side => 'left',
			-anchor => 'n',
			-fill => "none",
			-expand => 0);

my $varPrincipleFunction = "SELECT FUNCTION";
my $frame_principleFunction= $frameKeyRunSetUpLeft ->Frame()
	-> pack(
			-side => 'top',
			-fill => "none",
			-anchor => 'w',
			-expand => 0);

	my $labelPrincipleFunction_frame = $frame_principleFunction->Label(
				-text => 'Function:',
				-takefocus => 0,
				-width => 10,
				-state => 'normal',
				-anchor => 'w'
				)
				-> pack(
					-ipadx => 20,
					-side => 'left',
					-fill => "none",
					-expand => 0);

	my $principleFunction = $frame_principleFunction ->BrowseEntry(
			#-label => 'Function:              ',
			-listwidth => 208,
			#-borderwidth => '0',
			#-relief =>'flat',
			-state => 'readonly',
			-colorstate => '1',
			#-autolistwidth => '1',
			-autolimitheight => '1',
			-variable => \$varPrincipleFunction,
			-foreground => 'black',
			#-background => 'white',
			-width => 10, 
			-style => 'MSWin32',
			-buttontakefocus => 1);
	$principleFunction -> insert('end', qw(PeakCall DensityAnalyser SAMFilter TopPeaks RandomSAMReadSelection NumericalSort));
	
	$principleFunction -> pack(
				#-padx => 34.5,
				-ipadx => 71,
				-side => 'left',
				-fill => "both",
				-anchor => 'w',
				-expand => 0);

	my $choosePrincipleFunction = $frame_principleFunction ->Button(
			-text => 'Choose', 
				-command => \&choosePrincipleFunction,
				
				-height => 0.6)
				-> pack(
					-side => 'left',
					#-ipadx => 1.25,
					-fill => "none",
					-expand => 0);

#file selection for target file:
my $principleFilename = 'input file';
		my $frame_principleFile = $frameKeyRunSetUpLeft ->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-anchor => 'w',
					-expand => 0);

		my $labelPrincipleFile_frame = $frame_principleFile->Label(
				-text => 'Target filename:',
				-takefocus => 0,
				-width => 10,
				-state => 'disabled',
				-anchor => 'w'
				)
				-> pack(
					-ipadx => 20,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $entryPrincipleFile_frame = $frame_principleFile->Entry(
				-takefocus => 1,
				-width => 10,
				-exportselection => 1,
				-state => 'disabled',
				-textvariable => \$principleFilename,
				-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
				-> pack(
					-ipadx => 80,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $buttonPrincipleFile_frame = $frame_principleFile->Button(
				-text => 'Browse', 
				-state => 'disabled',
				-command => \&fileBrowseSelection,
				-height => 0.6)
				-> pack(
					-side => 'right',
					-fill => "none",
					-expand => 0);

#file selection for output file:
my $OutPutFilename = 'output file';
		my $frame_OutputFile = $frameKeyRunSetUpLeft ->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-anchor => 'w',
					-expand => 0);

		my $labelOutputFile_frame = $frame_OutputFile->Label(
				-text => 'Output filename:',
				-takefocus => 0,
				-width => 10,
				-state => 'disabled',
				-anchor => 'w'
				)
				-> pack(
					-ipadx => 20,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $entryOutputFile_frame = $frame_OutputFile->Entry(
				-takefocus => 1,
				-width => 10,
				-state => 'disabled',
				-exportselection => 1,
				-textvariable => \$OutPutFilename,
				-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
				-> pack(
					-ipadx => 80,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $buttonOutputFile_frame = $frame_OutputFile->Button(
				-text => 'Browse', 
				-state => 'disabled',

				-command => \&outputFileBrowseSelection,
				-height => 0.6)
				-> pack(
					-side => 'right',
					-fill => "none",
					-expand => 0);

#file selection for genomesizefile:
		my $frame_genomeSizeFile = $frameKeyRunSetUpRight ->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-anchor => 'n',
					-expand => 0);

		my $labelgenomeSize_frame = $frame_genomeSizeFile->Label(
				-text => 'chr size filename: ',
				-takefocus => 0,
				-state => 'disabled',
				-width => 10,
				-anchor => 'w'
				)
				-> pack(
					-ipadx => 20,
					-side => 'left',
					-fill => "none",
					-expand => 0);

my $genomeFilename; 
		my $entrygenomeSize_frame = $frame_genomeSizeFile->Entry(
				-takefocus => 1,
				-width => 10,
				-state => 'disabled',
				-exportselection => 1,
				-textvariable => \$genomeFilename,
				-background => 'white',  -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
				-> pack(
					-ipadx => 80,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $buttongenomeSize_frame = $frame_genomeSizeFile->Button(
				-text => 'Browse',
				-state => 'disabled', 
				-command => \&genomeFileBrowseSelection,
				-height => 0.6)
				-> pack(
					-side => 'right',
					-fill => "none",
					-expand => 0);

my $defaultOptional = 'NOT SELECTED';
#file selection for optional:
		my $frame_OptionalFile = $frameKeyRunSetUpRight ->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-anchor => 'n',
					-expand => 0);

		my $label_Optional_frame = $frame_OptionalFile->Label(
				-text => 'optional file: ',
				-takefocus => 0,
				-width => 10,
				-state => 'disabled',
				-anchor => 'w'
				)
				-> pack(
					-ipadx => 20,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my  $entry_Optional_frame = $frame_OptionalFile->Entry(
				-takefocus => 1,
				-width => 10,
				-textvariable => \$defaultOptional,
				-state => 'disabled',
				-exportselection => 1,
				-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
				-> pack(
					-ipadx => 80,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $button_Optional_frame = $frame_OptionalFile->Button(
				-text => 'Browse',
				-state => 'disabled', 
				-command => \&optionalFileBrowseSelection,
				-height => 0.6)
				-> pack(
					-side => 'right',
					-fill => "none",
					-expand => 0);

my $checkboxOverwrite = 'NO';
my $frame_OverwriteFile = $frameKeyRunSetUpRight ->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-anchor => 'w',
					-expand => 0);

	my $label_OverwriteFile = $frame_OverwriteFile->Label (
	       -text => 'Allow overwriting of existing files: ',
				-takefocus => 0,
				-width => 30,
				-state => 'disabled',
				-anchor => 'w'
				)
				-> pack(
					-ipadx => 3,
					-ipady => 5,
					-side => 'left',
					-fill => "none",
					-expand => 0);
        
	my $checkbox_OverwriteFile = $frame_OverwriteFile->Checkbox (
		        -variable => \$checkboxOverwrite,
		        -state => 'disabled',
		        -onvalue  => 'YES',
		        -offvalue => 'NO',
		        -height => 10,
		        
		   )->pack (
		   	-pady => 2,
		   	-side => 'left',
					-fill => "none",
					-expand => 0);

my $keyRunHeight = 8.5*($frameKeyRunSetUp -> height);
my $frameButtonRunSetUp = $frameKeyRunSetUp -> Frame ()
	-> pack(
			-ipadx => 50,
			-anchor => 'w',
			-side => 'left',
			-fill => "both",
			-expand => 1, 
			);

	my $goButton_frame = $frameButtonRunSetUp -> Frame()
		-> pack(
			-side => 'top',
			-fill => "both",
			#-anchor => 'n',
			-expand => 1, 
			);	

		my $goButton_button = $goButton_frame -> Button(
				-text => 'Run',
				-state => 'disabled', 
				-command => \&runPeaKDEck
				)
				-> pack(
					-side => 'top',
					-fill => "both",
					-expand => 1);	

# Top level options frame ---------------------------------------------
my $frameOptions = $mw -> Frame()
		-> pack(
			-side => 'top',
			-fill => "x",
			-expand => 0);

# Individual options frames ---------------------------------------------

	my $frameOptions_PeakCall = $frameOptions->Frame(-borderwidth => 2, -relief => 'groove')
			-> pack(
				-side => 'left',
				-fill => "none",
				-anchor => 'n',
				-expand => 0);

	my $frameOptions_DensityAnalyzer = $frameOptions->Frame(-borderwidth => 2, -relief => 'groove')
			-> pack(
				-side => 'left',
				-fill => "none",
				-anchor => 'n',
				-expand => 0);

	my $frameOptions_SAMFilter = $frameOptions->Frame(-borderwidth => 2, -relief => 'groove')
			-> pack(
				-side => 'left',
				-fill => "none",
				-anchor => 'n',
				-expand => 0);

	my $frameOptions_TopPeaks = $frameOptions->Frame(-borderwidth => 2, -relief => 'groove')
			-> pack(
				-side => 'left',
				-fill => "none",
				-anchor => 'n',
				-expand => 0);

	my $frameOptions_RandomSamReadSelection = $frameOptions->Frame(-borderwidth => 2, -relief => 'groove')
			-> pack(
				-side => 'left',
				-fill => "none",
				-anchor => 'n',
				-expand => 0);

	my $frameOptions_NumericalSort = $frameOptions->Frame(-borderwidth => 2, -relief => 'groove')
			-> pack(
				-side => 'left',
				-fill => "none",
				-anchor => 'n',
				-expand => 0);

my @peakCallerOptions = ('300', '3000', '50', '0.001', '50000', 'NONE', 'OFF');
##Option widgets for PeakCall
# Top level label ---------------------------------------------
	my $label_Options_PeakCall = $frameOptions_PeakCall->Label(
			-text => 'PeakCall options',
			-takefocus => 0,
			-width => 20,
			-state => 'disabled',
			-anchor => 'c'
			)
			-> pack(
				-side => 'top',
				-fill => "none",
				-expand => 1);

		# Option widget package ---------------------------------------------
		my $varOneFrame_frameOptions_PeakCall = $frameOptions_PeakCall->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarOne_Options_PeakCall = $varOneFrame_frameOptions_PeakCall->Label(
					-text => 'Bin size:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarOne_Options_PeakCall = $varOneFrame_frameOptions_PeakCall->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$peakCallerOptions[0],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varTwoFrame_frameOptions_PeakCall = $frameOptions_PeakCall->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarTwo_Options_PeakCall = $varTwoFrame_frameOptions_PeakCall->Label(
					-text => 'Back size:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarTwo_Options_PeakCall = $varTwoFrame_frameOptions_PeakCall->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$peakCallerOptions[1],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------

		my $varThreeFrame_frameOptions_PeakCall = $frameOptions_PeakCall->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarThree_Options_PeakCall = $varThreeFrame_frameOptions_PeakCall->Label(
					-text => 'Step size:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarThree_Options_PeakCall = $varThreeFrame_frameOptions_PeakCall->Entry(
					-text => "300",
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$peakCallerOptions[2],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varFourFrame_frameOptions_PeakCall = $frameOptions_PeakCall->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarFour_Options_PeakCall = $varFourFrame_frameOptions_PeakCall->Label(
					-text => 'p-value:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarFour_Options_PeakCall = $varFourFrame_frameOptions_PeakCall->Entry(
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$peakCallerOptions[3],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varFiveFrame_frameOptions_PeakCall = $frameOptions_PeakCall->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

				my $label_VarFive_Options_PeakCall = $varFiveFrame_frameOptions_PeakCall->Label(
						-text => 'npBack:',
						-takefocus => 0,
						-width => 10,
						-state => 'disabled',
						-anchor => 'w'
						)
						-> pack(
							-side => 'left',
							-fill => "none",
							-expand => 1);

				my $entry_VarFive_Options_PeakCall = $varFiveFrame_frameOptions_PeakCall->Entry(
						-takefocus => 1,
						-width => 10,
						-state => 'disabled',
						-textvariable => \$peakCallerOptions[4],
						-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
						-> pack(
							-side => 'right',
							-fill => "none",
							-expand => 1);    

# Option widget package ---------------------------------------------
		my $varSixFrame_frameOptions_PeakCall = $frameOptions_PeakCall->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

				my $label_VarSix_Options_PeakCall = $varSixFrame_frameOptions_PeakCall->Label(
						-text => 'Flat thresh:',
						-takefocus => 0,
						-width => 10,
						-state => 'disabled',
						-anchor => 'w'
						)
						-> pack(
							-side => 'left',
							-fill => "none",
							-expand => 1);

				my $entry_VarSix_Options_PeakCall = $varSixFrame_frameOptions_PeakCall->Entry(
						-takefocus => 1,
						-width => 10,
						-state => 'disabled',
						-textvariable => \$peakCallerOptions[5],
						-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
						-> pack(
							-side => 'right',
							-fill => "none",
							-expand => 1);    

# Option widget package ---------------------------------------------
		my $varSevenFrame_frameOptions_PeakCall = $frameOptions_PeakCall->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-anchor => 'w',
					-expand => 0);

			my $label_VarSeven_Options_PeakCall = $varSevenFrame_frameOptions_PeakCall->Label(
					-text => 'PVAL score:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);
			
			my $radio_VarSeven_frameOptions_PeakCall_ON = $varSevenFrame_frameOptions_PeakCall ->Radiobutton(
								-text => 'ON', 
								-state => 'disabled',
								-variable => \$peakCallerOptions[6],
								-value => 'ON'
								)
									
								->pack(-side => 'top', -anchor =>'w');


				my $radio_VarSeven_frameOptions_PeakCall_OFF = $varSevenFrame_frameOptions_PeakCall ->Radiobutton(
								-text => 'OFF', 
								-state => 'disabled',
								-variable => \$peakCallerOptions[6],
								-value => 'OFF'
								)
									
								->pack(-side => 'top', -anchor =>'w');

my @densityAnalyzerOptions = ('150', '100', '50', 'DEFAULT', '100000000', '0');
##Option widgets for DensityAnalyzer
# Top level label ---------------------------------------------
	my $label_Options_DensityAnalyzer = $frameOptions_DensityAnalyzer->Label(
			-text => 'DensityAnalyzer options',
			-takefocus => 0,
			-width => 20,
			-state => 'disabled',
			-anchor => 'c'
			)
			-> pack(
				-side => 'top',
				-fill => "none",
				-expand => 1);

# Option widget package ---------------------------------------------
		my $varOneFrame_frameOptions_DensityAnalyzer = $frameOptions_DensityAnalyzer->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",

					-expand => 0);

			my $label_VarOne_Options_DensityAnalyzer = $varOneFrame_frameOptions_DensityAnalyzer->Label(
					-text => '1/2 Bin size:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarOne_Options_DensityAnalyzer = $varOneFrame_frameOptions_DensityAnalyzer->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$densityAnalyzerOptions[0],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varTwoFrame_frameOptions_DensityAnalyzer = $frameOptions_DensityAnalyzer->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarTwo_Options_DensityAnalyzer = $varTwoFrame_frameOptions_DensityAnalyzer->Label(
					-text => 'Step size:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarTwo_Options_DensityAnalyzer = $varTwoFrame_frameOptions_DensityAnalyzer->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$densityAnalyzerOptions[1],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varThreeFrame_frameOptions_DensityAnalyzer = $frameOptions_DensityAnalyzer->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarThree_Options_DensityAnalyzer = $varThreeFrame_frameOptions_DensityAnalyzer->Label(
					-text => 'Sigma: ',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarThree_Options_DensityAnalyzer = $varThreeFrame_frameOptions_DensityAnalyzer->Entry(
					-text => "300",
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$densityAnalyzerOptions[2],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varFourFrame_frameOptions_DensityAnalyzer = $frameOptions_DensityAnalyzer->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarFour_Options_DensityAnalyzer = $varFourFrame_frameOptions_DensityAnalyzer->Label(
					-text => 'Min thresh',
					-takefocus => 0,
					-state => 'disabled',
					-width => 10,
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarFour_Options_DensityAnalyzer = $varFourFrame_frameOptions_DensityAnalyzer->Entry(
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$densityAnalyzerOptions[3],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varFiveFrame_frameOptions_DensityAnalyzer = $frameOptions_DensityAnalyzer->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarFive_Options_DensityAnalyzer = $varFiveFrame_frameOptions_DensityAnalyzer->Label(
					-text => 'Max thresh: ',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarFive_Options_DensityAnalyzer = $varFiveFrame_frameOptions_DensityAnalyzer->Entry(
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$densityAnalyzerOptions[4],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);    

# Option widget package ---------------------------------------------
		my $varSixFrame_frameOptions_DensityAnalyzer = $frameOptions_DensityAnalyzer->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

				my $label_VarSix_Options_DensityAnalyzer = $varSixFrame_frameOptions_DensityAnalyzer->Label(
						-text => 'Offset: ',
						-takefocus => 0,
						-width => 10,
						-state => 'disabled',
						-anchor => 'w'
						)
						-> pack(
							-side => 'left',
							-fill => "none",
							-expand => 1);

				my $entry_VarSix_Options_DensityAnalyzer = $varSixFrame_frameOptions_DensityAnalyzer->Entry(
						-takefocus => 1,
						-width => 10,
						-state => 'disabled',
						-textvariable => \$densityAnalyzerOptions[5],
						-background => 'white',  -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
						-> pack(
							-side => 'right',
							-fill => "none",
							-expand => 1);    

my @SAMFilterOptions = ('0', '100000', 'OFF');

##Option widgets for SAMFilter
# Top level label ---------------------------------------------
	my $label_Options_SAMFilter = $frameOptions_SAMFilter->Label(
			-text => 'SAMFilter options',
			-takefocus => 0,
			-width => 20,
			-state => 'disabled',
			-anchor => 'c'
			)
			-> pack(
				-side => 'top',
				-fill => "none",
				-expand => 1);

# Option widget package ---------------------------------------------
		my $varOneFrame_frameOptions_SAMFilter = $frameOptions_SAMFilter->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarOne_Options_SAMFilter = $varOneFrame_frameOptions_SAMFilter->Label(
					-text => 'MapQ limit:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarOne_Options_SAMFilter = $varOneFrame_frameOptions_SAMFilter->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$SAMFilterOptions[0],
					-background => 'white',  -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varTwoFrame_frameOptions_SAMFilter = $frameOptions_SAMFilter->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarTwo_Options_SAMFilter = $varTwoFrame_frameOptions_SAMFilter->Label(
					-text => 'UQ limit:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarTwo_Options_SAMFilter = $varTwoFrame_frameOptions_SAMFilter->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$SAMFilterOptions[1],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

# Option widget package ---------------------------------------------
		my $varThreeFrame_frameOptions_SAMFilter = $frameOptions_SAMFilter->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-anchor => 'w',
					-expand => 0);

			my $label_VarThree_Options_SAMFilter = $varThreeFrame_frameOptions_SAMFilter->Label(
					-text => 'PCR delete:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);
			
			my $radio_VarThree_Options_SAMFilter_ON = $varThreeFrame_frameOptions_SAMFilter->Radiobutton(
								-text => 'ON', 
								-state => 'disabled',
								-variable => \$SAMFilterOptions[2],
								-value => 'ON')
									
								->pack(-side => 'top', -anchor =>'w');
					

			my $radio_VarThree_Options_SAMFilter_OFF = $varThreeFrame_frameOptions_SAMFilter->Radiobutton(
					-text => 'OFF', 
					-state => 'disabled',
					-variable => \$SAMFilterOptions[2],
					-value => 'OFF')
						
					->pack(-side => 'top', -anchor =>'w');

my @topPeaksOptions = ('ALL');
##Option widgets for TopPeaks
# Top level label ---------------------------------------------
	my $label_Options_TopPeaks = $frameOptions_TopPeaks->Label(
			-text => 'TopPeaks options',
			-takefocus => 0,
			-width => 20,
			-state => 'disabled',
			-anchor => 'c'
			)
			-> pack(
				-side => 'top',
				-fill => "none",
				-expand => 1);

# Option widget package ---------------------------------------------
		my $varOneFrame_frameOptions_TopPeaks = $frameOptions_TopPeaks->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarOne_Options_TopPeaks = $varOneFrame_frameOptions_TopPeaks->Label(
					-text => 'Number: ',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarOne_Options_TopPeaks = $varOneFrame_frameOptions_TopPeaks->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$topPeaksOptions[0],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

my @randomReadOptions = ('1000000');
##Option widgets for RandomSamReadSelection
# Top level label ---------------------------------------------
	my $label_Options_RandomSAMReadSelection = $frameOptions_RandomSamReadSelection->Label(
			-text => 'Random read options',
			-takefocus => 0,
			-width => 20,
			-state => 'disabled',
			-anchor => 'c'
			)
			-> pack(
				-side => 'top',
				-fill => "none",
				-expand => 1);

# Option widget package ---------------------------------------------
		my $varOneFrame_frameOptions_RandomSAMReadSelection = $frameOptions_RandomSamReadSelection->Frame()
				-> pack(
					-side => 'top',
					-fill => "none",
					-expand => 0);

			my $label_VarOne_Options_RandomSAMReadSelection = $varOneFrame_frameOptions_RandomSAMReadSelection->Label(
					-text => 'Number:',
					-takefocus => 0,
					-width => 10,
					-state => 'disabled',
					-anchor => 'w'
					)
					-> pack(
						-side => 'left',
						-fill => "none",
						-expand => 1);

			my $entry_VarOne_Options_RandomSAMReadSelection = $varOneFrame_frameOptions_RandomSAMReadSelection->Entry(
					-text => '300',
					-takefocus => 1,
					-width => 10,
					-state => 'disabled',
					-textvariable => \$randomReadOptions[0],
					-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
					-> pack(
						-side => 'right',
						-fill => "none",
						-expand => 1);

##Option widgets for NumericalSort
# Top level label ---------------------------------------------
my $label_Options_NumericalSort = $frameOptions_NumericalSort->Label(
		-text => 'NumericalSort options',
		-takefocus => 0,
		-width => 20,
		-state => 'disabled',
		-anchor => 'c',
		
		)
		-> pack(
			-side => 'top',
			-fill => "none",
			-ipadx => 5,
			-expand => 1);

my $frame_Screen = $mw -> Frame(-borderwidth => 2, -relief => 'groove')->pack(
			-side => 'top',
			-fill => "both",
			-anchor => 'w',
			-expand => 1);

my $text_frameScreen = $frame_Screen -> ROText(-exportselection => 1, -background =>'black', -foreground => 'green', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)->pack(
			-side => 'top',
			-fill => "both",
			-anchor => 'w',
			-expand => 1);

my $frame_LogOut_Quit = $frame_Screen -> Frame()->pack(
			-side => 'top',
			-fill => "x",
			-anchor => 'w',
			-expand => 0);

my $logFilename = "$home"."$seps" . 'log.txt';
		my $frame_logFile = $frame_LogOut_Quit ->Frame()
				-> pack(
					-side => 'left',
					-fill => "none",
					-anchor => 'w',
					-expand => 0);

		my $labelLogFile_frame = $frame_logFile->Label(
				-text => 'Log filename:',
				-takefocus => 0,
				-width => 10,
				-state => 'normal',
				-anchor => 'w'
				)
				-> pack(
					-ipadx => 20,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $entryLogFile_frame = $frame_logFile->Entry(
				-takefocus => 1,
				-width => 10,
				-exportselection => 1,
				-state => 'normal',
				-textvariable => \$logFilename,
				-background => 'white', -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)
				-> pack(
					-ipadx => 80,
					-side => 'left',
					-fill => "none",
					-expand => 0);

		my $buttonLogFile_frame = $frame_logFile->Button(
				-text => 'Browse', 
				-state => 'normal',

				-command => \&logBrowseSelection,
				-height => 0.6)
				-> pack(
					-side => 'left',
					-fill => "none",
					-expand => 0);
		
		my $logButtonLogFile_frame = $frame_logFile->Button(
				-text => 'Log screen to file', 
				-state => 'normal',

				-command => \&logScreenToFile,
				-height => 0.6)
				-> pack(
					-side => 'left',
					-fill => "none",
					-expand => 0);
		
		my $buttonQuit_frame = $frame_LogOut_Quit->Button(
				-text => 'Quit', 
				-state => 'normal',
				-command => \&quitProgram,
				-height => 0.6)
				-> pack(
					-side => 'right',
					-anchor => 'w',
					-fill => "none",
					-expand => 0);
		
		my $buttonStop_frame = $frame_LogOut_Quit->Button(
						-text => 'Disrupt at next refresh', 
						-state => 'normal',
						-command => \&stopProgram,
						-height => 0.6)
						-> pack(
							-side => 'right',
							-anchor => 'w',
							-fill => "none",
							-expand => 0);

		my $buttonHelp_frame = $frame_LogOut_Quit->Button(
						-text => 'Help', 
						-state => 'normal',
						-command => \&launchHelp,
						-height => 0.6)
						-> pack(
							-side => 'right',
							-anchor => 'w',
							-fill => "none",
							-expand => 0);

#The next line binds all subsequent STDERR calls to the ROText widget:
tie *STDERR, ref $text_frameScreen, $text_frameScreen;


MainLoop;


sub launchHelp
	{
		my $helper = $mw->Toplevel();
		$helper ->maxsize(820,1050);
		$helper ->minsize(820,650);
		$helper ->title("PeaKDEck v1.1 Help");
		$helper->Icon(-image => $mw->Pixmap(-data => $pixmap_data));
		my $helpFrame = $helper->Frame()
		-> pack(
					-side => 'left',
					-fill => "both",
					-anchor => 'w',
					-expand => 1);

		my $text_helpFrame = $helpFrame -> Scrolled('ROText', -exportselection => 1, -scrollbars=> 'se', -background =>'white', -foreground => 'black',  -selectbackground => 'blue', -selectforeground => 'white', -selectborderwidth => 0)->pack(
			-side => 'top',
			-fill => "both",
			-anchor => 'w',
			-expand => 1);
		
		my $data = helpUsage();
			
		my $indentLevel = '';
		my $count;
		
		$data =~ s/=head1 //g;
		$data =~ s/=head2 /   /g;
		$data =~ s/=head3 /      /g;
		$data =~ s/=cut//g;
		$data =~ s/I<//g;
		$data =~ s/>//g;

		$text_helpFrame->Insert("$data");
		$text_helpFrame->GotoLineNumber(1);

	}

sub quitProgram
	{
		my $response = $mw->messageBox(-icon => 'question', -message => 'Quit program?', -title => 'Quit', -type => 'OkCancel', -default => 'Cancel');
		if ($response eq 'Ok')
			{
				if (@tempFileList > 0)
					{
						for (@tempFileList)
							{
								unlink $_;
							}
					}

				exit ;
			}
	}


sub logScreenToFile
	{
		my $okToLog = 0;
		my $outputLogFile = $entryLogFile_frame -> cget('-textvariable');
		$text_frameScreen -> selectAll;
		my @log = $text_frameScreen -> SelectionGet;
		$text_frameScreen -> unselectAll;
		
		for (@log)
			{
				if ($_ =~ m/\w/)
					{
						$okToLog += 1;
						last;
					}
			}
	
		if ($okToLog > 0)
			{
				open (my $logFile, ">>", $$outputLogFile) || die  "Unable to open $outputLogFile\n\n";

				print $logFile "$timeString\n";
				for (@log)
					{
						print $logFile "$_";
					}
				close $logFile;

				print STDERR "Copied screen to $$outputLogFile.\n";
			}
		else
			{
				print STDERR "Nothing to log.\n";
			}
		
	}

sub choosePrincipleFunction
	{
		my $functional = $principleFunction -> cget(-variable => \$varPrincipleFunction);
		my $option = $$functional;
		
		my @overwriteCheckboxWidgets =($label_OverwriteFile, $checkbox_OverwriteFile);
		my @principleFunctionWidgets = ($principleFunction, $labelPrincipleFunction_frame, $choosePrincipleFunction);		
		my @outputFileWidgets = ($labelOutputFile_frame, $entryOutputFile_frame, $buttonOutputFile_frame);
		my @principleFileWidgets = ($labelPrincipleFile_frame, $entryPrincipleFile_frame, $buttonPrincipleFile_frame );
		my @genomeSizeFileWidgets = ($labelgenomeSize_frame, $entrygenomeSize_frame, $buttongenomeSize_frame);
		my @optionalFileWidgets = ($label_Optional_frame, $entry_Optional_frame, $button_Optional_frame);
		my @PeakCallWidgets = ($label_Options_PeakCall, $label_VarOne_Options_PeakCall, $entry_VarOne_Options_PeakCall, $label_VarTwo_Options_PeakCall, $entry_VarTwo_Options_PeakCall, $label_VarThree_Options_PeakCall, $entry_VarThree_Options_PeakCall, $label_VarFour_Options_PeakCall, $entry_VarFour_Options_PeakCall, $label_VarFive_Options_PeakCall, $entry_VarFive_Options_PeakCall, $label_VarSix_Options_PeakCall, $entry_VarSix_Options_PeakCall, $label_VarSeven_Options_PeakCall, $radio_VarSeven_frameOptions_PeakCall_ON, $radio_VarSeven_frameOptions_PeakCall_OFF);
		my @DensityAnalyzerWidgets = ($label_Options_DensityAnalyzer, $label_VarOne_Options_DensityAnalyzer, $entry_VarOne_Options_DensityAnalyzer, $label_VarTwo_Options_DensityAnalyzer, $entry_VarTwo_Options_DensityAnalyzer, $label_VarThree_Options_DensityAnalyzer, $entry_VarThree_Options_DensityAnalyzer, $label_VarFour_Options_DensityAnalyzer, $entry_VarFour_Options_DensityAnalyzer, $label_VarFive_Options_DensityAnalyzer, $entry_VarFive_Options_DensityAnalyzer, $label_VarSix_Options_DensityAnalyzer, $entry_VarSix_Options_DensityAnalyzer);
		my @SAMFilterWidgets = ($label_Options_SAMFilter, $label_VarOne_Options_SAMFilter, $entry_VarOne_Options_SAMFilter, $label_VarTwo_Options_SAMFilter, $entry_VarTwo_Options_SAMFilter, $label_VarThree_Options_SAMFilter, $radio_VarThree_Options_SAMFilter_ON, $radio_VarThree_Options_SAMFilter_OFF);
		my @TopPeaksWidgets = ($label_Options_TopPeaks, $label_VarOne_Options_TopPeaks, $entry_VarOne_Options_TopPeaks);
		my @RandomSAMReadSelectionWidgets = ($label_Options_RandomSAMReadSelection, $label_VarOne_Options_RandomSAMReadSelection, $entry_VarOne_Options_RandomSAMReadSelection);
		my @NumericalSortWidgets = ($label_Options_NumericalSort);
		
		$principleFunction -> configure(-state => 'readonly');
		$choosePrincipleFunction -> configure(-state => 'normal');


		for (@principleFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'normal') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'normal') if $option eq "TopPeaks";
				$_ -> configure(-state => 'normal') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'normal') if $option eq "NumericalSort";
			}


		for (@optionalFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'disable') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'disable') if $option eq "TopPeaks";
				$_ -> configure(-state => 'disable') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'disable') if $option eq "NumericalSort";
			}

		$label_Optional_frame -> configure(-text => 'optional file:');
		$label_Optional_frame -> configure(-text => 'blueprint file (opt):') if $option eq "PeakCall";
		$label_Optional_frame -> configure(-text => 'sam header (opt):') if $option eq "SAMFilter";

		for (@outputFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'normal') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'normal') if $option eq "TopPeaks";
				$_ -> configure(-state => 'normal') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'normal') if $option eq "NumericalSort";
			}

		for (@genomeSizeFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'normal') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'disable') if $option eq "TopPeaks";
				$_ -> configure(-state => 'disable') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'disable') if $option eq "NumericalSort";
			}

		for (@PeakCallWidgets)
			{
				if ($option eq "PeakCall")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}

		for (@DensityAnalyzerWidgets)
			{
				if ($option eq "DensityAnalyser")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}


		for (@SAMFilterWidgets)
			{
				if ($option eq "SAMFilter")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}


		for (@TopPeaksWidgets)
			{
				if ($option eq "TopPeaks")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}

		for (@RandomSAMReadSelectionWidgets)
			{
				if ($option eq "RandomSAMReadSelection")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}


		for (@NumericalSortWidgets)
			{
				if ($option eq "NumericalSort")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}


		if ($option eq "NumericalSort")
			{
				my $mainFile = "$home" . "$seps". 'filename.sam';
				my $OutPutFile =   "$home" . "$seps".'sortedFilename.sam';
				$entryPrincipleFile_frame -> configure(-textvariable => \$mainFile);
				$entryOutputFile_frame-> configure(-textvariable => \$OutPutFile);
				$entryPrincipleFile_frame->xview('end');
				$entryOutputFile_frame->xview('end');
				
				$label_OverwriteFile -> configure(-state => 'normal');
				$checkbox_OverwriteFile -> configure(-state => 'normal');
				$goButton_button -> configure(-state => 'normal');
			}

		if ($option eq "PeakCall")
			{
				my $mainFile = "$home" . "$seps" . 'filename.sam';
				my $OutPutFile =   "$home" . "$seps" . 'peaks.bed';
				$entryPrincipleFile_frame -> configure(-textvariable => \$mainFile);
				$entryOutputFile_frame-> configure(-textvariable => \$OutPutFile);
				$entryPrincipleFile_frame->xview('end');
				$entryOutputFile_frame->xview('end');
				
				$label_OverwriteFile -> configure(-state => 'normal');
				$checkbox_OverwriteFile -> configure(-state => 'normal');
				$goButton_button -> configure(-state => 'normal');
			}

		if ($option eq "DensityAnalyser")
			{
				my $mainFile = "$home" . "$seps" . 'filename.sam';
				my $OutPutFile =   "$home" . "$seps" . 'density.wig';
				$entryPrincipleFile_frame -> configure(-textvariable => \$mainFile);
				$entryOutputFile_frame-> configure(-textvariable => \$OutPutFile);
				$entryPrincipleFile_frame->xview('end');
				$entryOutputFile_frame->xview('end');
				
				$label_OverwriteFile -> configure(-state => 'normal');
				$checkbox_OverwriteFile -> configure(-state => 'normal');
				$goButton_button -> configure(-state => 'normal');
			}

		if ($option eq "TopPeaks")
			{
				my $mainFile = "$home" . "$seps" . 'peaks.bed';
				my $OutPutFile =   "$home" . "$seps" . 'ordered_peaks.bed';
				$entryPrincipleFile_frame -> configure(-textvariable => \$mainFile);
				$entryOutputFile_frame-> configure(-textvariable => \$OutPutFile);
				$entryPrincipleFile_frame->xview('end');
				$entryOutputFile_frame->xview('end');
				
				$label_OverwriteFile -> configure(-state => 'normal');
				$checkbox_OverwriteFile -> configure(-state => 'normal');
				$goButton_button -> configure(-state => 'normal');
			}

		if ($option eq "SAMFilter")
			{
				my $mainFile = "$home" . "$seps" . 'filename.sam';
				my $OutPutFile =   "$home" . "$seps" . 'filtered_filename.sam';
				$entryPrincipleFile_frame -> configure(-textvariable => \$mainFile);
				$entryOutputFile_frame-> configure(-textvariable => \$OutPutFile);
				$entryPrincipleFile_frame->xview('end');
				$entryOutputFile_frame->xview('end');
				
				$label_OverwriteFile -> configure(-state => 'normal');
				$checkbox_OverwriteFile -> configure(-state => 'normal');
				$goButton_button -> configure(-state => 'normal');
			}

		if ($option eq "RandomSAMReadSelection")
			{
				my $mainFile = "$home" . "$seps" . 'filename.sam';
				my $OutPutFile =   "$home" . "$seps" . 'random_selection.sam';
				$entryPrincipleFile_frame -> configure(-textvariable => \$mainFile);
				$entryOutputFile_frame-> configure(-textvariable => \$OutPutFile);
				$entryPrincipleFile_frame->xview('end');
				$entryOutputFile_frame->xview('end');
				$label_OverwriteFile -> configure(-state => 'normal');
				$checkbox_OverwriteFile -> configure(-state => 'normal');
				$goButton_button -> configure(-state => 'normal');
			}

	}



sub endRunOrAbort
	{
		my $functional = $principleFunction -> cget(-variable => \$varPrincipleFunction);
		my $option = $$functional;
						
		my @overwriteCheckboxWidgets =($label_OverwriteFile, $checkbox_OverwriteFile);
		my @principleFunctionWidgets = ($principleFunction, $labelPrincipleFunction_frame, $choosePrincipleFunction);		
		my @outputFileWidgets = ($labelOutputFile_frame, $entryOutputFile_frame, $buttonOutputFile_frame);
		my @principleFileWidgets = ($labelPrincipleFile_frame, $entryPrincipleFile_frame, $buttonPrincipleFile_frame );
		my @genomeSizeFileWidgets = ($labelgenomeSize_frame, $entrygenomeSize_frame, $buttongenomeSize_frame);
		my @optionalFileWidgets = ($label_Optional_frame, $entry_Optional_frame, $button_Optional_frame);
		my @PeakCallWidgets = ($label_Options_PeakCall, $label_VarOne_Options_PeakCall, $entry_VarOne_Options_PeakCall, $label_VarTwo_Options_PeakCall, $entry_VarTwo_Options_PeakCall, $label_VarThree_Options_PeakCall, $entry_VarThree_Options_PeakCall, $label_VarFour_Options_PeakCall, $entry_VarFour_Options_PeakCall, $label_VarFive_Options_PeakCall, $entry_VarFive_Options_PeakCall, $label_VarSix_Options_PeakCall, $entry_VarSix_Options_PeakCall, $label_VarSeven_Options_PeakCall, $radio_VarSeven_frameOptions_PeakCall_ON, $radio_VarSeven_frameOptions_PeakCall_OFF);
		my @DensityAnalyzerWidgets = ($label_Options_DensityAnalyzer, $label_VarOne_Options_DensityAnalyzer, $entry_VarOne_Options_DensityAnalyzer, $label_VarTwo_Options_DensityAnalyzer, $entry_VarTwo_Options_DensityAnalyzer, $label_VarThree_Options_DensityAnalyzer, $entry_VarThree_Options_DensityAnalyzer, $label_VarFour_Options_DensityAnalyzer, $entry_VarFour_Options_DensityAnalyzer, $label_VarFive_Options_DensityAnalyzer, $entry_VarFive_Options_DensityAnalyzer, $label_VarSix_Options_DensityAnalyzer, $entry_VarSix_Options_DensityAnalyzer);
		my @SAMFilterWidgets = ($label_Options_SAMFilter, $label_VarOne_Options_SAMFilter, $entry_VarOne_Options_SAMFilter, $label_VarTwo_Options_SAMFilter, $entry_VarTwo_Options_SAMFilter, $label_VarThree_Options_SAMFilter, $radio_VarThree_Options_SAMFilter_ON, $radio_VarThree_Options_SAMFilter_OFF);
		my @TopPeaksWidgets = ($label_Options_TopPeaks, $label_VarOne_Options_TopPeaks, $entry_VarOne_Options_TopPeaks);
		my @RandomSAMReadSelectionWidgets = ($label_Options_RandomSAMReadSelection, $label_VarOne_Options_RandomSAMReadSelection, $entry_VarOne_Options_RandomSAMReadSelection);
		my @NumericalSortWidgets = ($label_Options_NumericalSort);
				
		$principleFunction -> configure(-state => 'readonly');
		$choosePrincipleFunction -> configure(-state => 'normal');
		$labelPrincipleFunction_frame -> configure(-state => 'normal');


		for (@principleFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'normal') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'normal') if $option eq "TopPeaks";
				$_ -> configure(-state => 'normal') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'normal') if $option eq "NumericalSort";
			}


		for (@optionalFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'disable') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'disable') if $option eq "TopPeaks";
				$_ -> configure(-state => 'disable') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'disable') if $option eq "NumericalSort";
			}

		$label_Optional_frame -> configure(-text => 'optional file:');
		$label_Optional_frame -> configure(-text => 'blueprint file (opt):') if $option eq "PeakCall";
		$label_Optional_frame -> configure(-text => 'sam header (opt):') if $option eq "SAMFilter";

		for (@outputFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'normal') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'normal') if $option eq "TopPeaks";
				$_ -> configure(-state => 'normal') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'normal') if $option eq "NumericalSort";
			}

		for (@genomeSizeFileWidgets)
			{
				$_ -> configure(-state => 'normal') if $option eq "PeakCall";
				$_ -> configure(-state => 'normal') if $option eq "DensityAnalyser";
				$_ -> configure(-state => 'normal') if $option eq "SAMFilter";
				$_ -> configure(-state => 'disable') if $option eq "TopPeaks";
				$_ -> configure(-state => 'disable') if $option eq "RandomSAMReadSelection";
				$_ -> configure(-state => 'disable') if $option eq "NumericalSort";
			}

		for (@overwriteCheckboxWidgets)
			{
				$_ -> configure(-state => 'normal');
			}

		for (@PeakCallWidgets)
			{
				if ($option eq "PeakCall")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}

		for (@DensityAnalyzerWidgets)
			{
				if ($option eq "DensityAnalyser")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}


		for (@SAMFilterWidgets)
			{
				if ($option eq "SAMFilter")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}


		for (@TopPeaksWidgets)
			{
				if ($option eq "TopPeaks")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}

		for (@RandomSAMReadSelectionWidgets)
			{
				if ($option eq "RandomSAMReadSelection")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}


		for (@NumericalSortWidgets)
			{
				if ($option eq "NumericalSort")
					{
						$_ -> configure(-state => 'normal')
					}
				else
					{
						$_ -> configure(-state => 'disable');
					}
			}

		$logButtonLogFile_frame -> configure(-state =>'normal');
		$goButton_button -> configure(-state => 'normal');

		if (@tempFileList > 0)
			{
				for (@tempFileList)
					{
						unlink $_;
					}
			}


	}

sub fileBrowseSelection
	{
		my $file;
		$file = $mw->getOpenFile(-initialdir => "$home");
		return unless $file;
		$file =~ s/\//\\/g; # windows only
		my($filename, $directories, $suffix) = fileparse($file) if $file =~ m/\w/;
		chop $directories if ($directories =~ m/[\\\/]$/);
		$home = $directories if $file =~ m/\w/;
		$entryPrincipleFile_frame->configure(-textvariable => \$file);
		$entryPrincipleFile_frame->xview('end');
		message("Selected target file: $file") if $file =~ m/\w/;
	}


sub stopProgram
	{
		$quit = 1;
		endRunOrAbort();
	}

sub logBrowseSelection
	{
		my $logOutFile;
		$logOutFile = $mw->getOpenFile(-initialdir => "$home");
		return unless $logOutFile;
		$logOutFile =~ s/\//\\/g; # windows only
		my($filename, $directories, $suffix) = fileparse($logOutFile) if $logOutFile =~ m/\w/;
		chop $directories if ($directories =~ m/[\\\/]$/);
		$home = $directories if $logOutFile =~ m/\w/;
		$entryLogFile_frame->configure(-textvariable => \$logOutFile);
		$entryLogFile_frame->xview('end');
		message("Selected target file: $logOutFile") if $logOutFile =~ m/\w/;
	}

sub Tk::Error
	{
		endRunOrAbort();
 		my ($widget,$error,@locations) = @_;
		print STDERR "\n[PD] Error: $error\n";
	}

sub message 
	{
		my $message = $_[0];
		print STDERR "$message\n";
	}

sub genomeFileBrowseSelection
	{
		my $file;
		$file = $mw->getOpenFile(-initialdir => "$home");
		return unless $file;
		$file =~ s/\//\\/g; # windows only
		my($filename, $directories, $suffix) = fileparse($file) if $file =~ m/\w/;
		chop $directories if ($directories =~ m/[\\\/]$/);
		$home = $directories if $file =~ m/\w/;
		$entrygenomeSize_frame->configure(-textvariable => \$file);
		$entrygenomeSize_frame->xview('end');
		message("Selected chr size file: $file") if $file =~ m/\w/;
	}

sub outputFileBrowseSelection
	{
		my $file;
		$file = $mw->getOpenFile(-initialdir => "$home");
		return unless $file;
		$file =~ s/\//\\/g; # windows only
		my($filename, $directories, $suffix) = fileparse($file)if $file =~ m/\w/;
		chop $directories if ($directories =~ m/[\\\/]$/);
		$home = $directories if $file =~ m/\w/;
		$entryOutputFile_frame->configure(-textvariable => \$file);
		$entryOutputFile_frame->xview('end');
		message("Selected output: $file") if $file =~ m/\w/;
	}

sub optionalFileBrowseSelection
	{
		my $file;
		
		$file = $mw->getOpenFile(-initialdir => "$home");
		return unless $file;
		$file =~ s/\//\\/g; # windows only
		my($filename, $directories, $suffix) = fileparse($file)if $file =~ m/\w/;
		chop $directories if ($directories =~ m/[\\\/]$/);
		$home = $directories if $file =~ m/\w/;
		$entry_Optional_frame->configure(-textvariable => \$file);
		$entry_Optional_frame->xview('end');
		message("Selected optional: $file") if $file =~ m/\w/;
	}

sub disableAllWidgets
	{
		my @overwriteCheckboxWidgets =($label_OverwriteFile, $checkbox_OverwriteFile);
		my @principleFunctionWidgets = ($principleFunction, $labelPrincipleFunction_frame, $choosePrincipleFunction);
		my @outputFileWidgets = ($labelOutputFile_frame, $entryOutputFile_frame, $buttonOutputFile_frame);
		my @principleFileWidgets = ($labelPrincipleFile_frame, $entryPrincipleFile_frame, $buttonPrincipleFile_frame );
		my @genomeSizeFileWidgets = ($labelgenomeSize_frame, $entrygenomeSize_frame, $buttongenomeSize_frame);
		my @optionalFileWidgets = ($label_Optional_frame, $entry_Optional_frame, $button_Optional_frame);
		my @PeakCallWidgets = ($label_Options_PeakCall, $label_VarOne_Options_PeakCall, $entry_VarOne_Options_PeakCall, $label_VarTwo_Options_PeakCall, $entry_VarTwo_Options_PeakCall, $label_VarThree_Options_PeakCall, $entry_VarThree_Options_PeakCall, $label_VarFour_Options_PeakCall, $entry_VarFour_Options_PeakCall, $label_VarFive_Options_PeakCall, $entry_VarFive_Options_PeakCall, $label_VarSix_Options_PeakCall, $entry_VarSix_Options_PeakCall, $label_VarSeven_Options_PeakCall, $radio_VarSeven_frameOptions_PeakCall_ON, $radio_VarSeven_frameOptions_PeakCall_OFF);
		my @DensityAnalyzerWidgets = ($label_Options_DensityAnalyzer, $label_VarOne_Options_DensityAnalyzer, $entry_VarOne_Options_DensityAnalyzer, $label_VarTwo_Options_DensityAnalyzer, $entry_VarTwo_Options_DensityAnalyzer, $label_VarThree_Options_DensityAnalyzer, $entry_VarThree_Options_DensityAnalyzer, $label_VarFour_Options_DensityAnalyzer, $entry_VarFour_Options_DensityAnalyzer, $label_VarFive_Options_DensityAnalyzer, $entry_VarFive_Options_DensityAnalyzer, $label_VarSix_Options_DensityAnalyzer, $entry_VarSix_Options_DensityAnalyzer);
		my @SAMFilterWidgets = ($label_Options_SAMFilter, $label_VarOne_Options_SAMFilter, $entry_VarOne_Options_SAMFilter, $label_VarTwo_Options_SAMFilter, $entry_VarTwo_Options_SAMFilter, $label_VarThree_Options_SAMFilter, $radio_VarThree_Options_SAMFilter_ON, $radio_VarThree_Options_SAMFilter_OFF);
		my @TopPeaksWidgets = ($label_Options_TopPeaks, $label_VarOne_Options_TopPeaks, $entry_VarOne_Options_TopPeaks);
		my @RandomSAMReadSelectionWidgets = ($label_Options_RandomSAMReadSelection, $label_VarOne_Options_RandomSAMReadSelection, $entry_VarOne_Options_RandomSAMReadSelection);
		my @NumericalSortWidgets = ($label_Options_NumericalSort);

		for (@overwriteCheckboxWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@principleFunctionWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@outputFileWidgets)
			{
				$_ -> configure(-state => 'disable');
			}

		for (@principleFileWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@genomeSizeFileWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@optionalFileWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@PeakCallWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@DensityAnalyzerWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@SAMFilterWidgets)
			{
				$_ -> configure(-state => 'disable');
			}

		for (@TopPeaksWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@RandomSAMReadSelectionWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		for (@NumericalSortWidgets)
			{
				$_ -> configure(-state => 'disable');
			}
		$goButton_button -> configure(-state => 'disable');
	}

sub runPeaKDEck
	{
				$logButtonLogFile_frame -> configure(-state =>'disable');
				my $functional = $principleFunction -> cget(-variable => \$varPrincipleFunction);
				my $option = $$functional;
				my $closedAndOpen = 'NO';
				
				my $widgetOutputFile = $entryOutputFile_frame  -> cget('-textvariable');
				my $OutPutFile = $$widgetOutputFile;

				my $checkInput = $entryPrincipleFile_frame -> cget('-textvariable');
				my $inputFileCheck = $$checkInput;

				chomp $inputFileCheck;
				chomp $OutPutFile;

				die "The output filename (set to \'$OutPutFile\' cannot be identical to the target filename (set to \'$inputFileCheck\')\n\n" if ($inputFileCheck eq $OutPutFile);

				$quit = 0;
				my $allowOverwriting = $checkbox_OverwriteFile -> cget(-variable => \$checkboxOverwrite);

				$text_frameScreen -> update();

				if (($$allowOverwriting eq 'NO') && (-e $OutPutFile))
					{
						die "$OutPutFile already exists. Use checkbox to permit overwriting.\n\n";
					}
				if (($$allowOverwriting eq 'YES') && (-e $OutPutFile))
					{
						print STDERR "\n\tWarning: overwriting $OutPutFile!\n" if -e $OutPutFile;
					}
				open ($resultsOut, ">", $OutPutFile) || die  "Unable to open $OutPutFile\n\n";
				
				if ($option eq 'PeakCall')
					{
						#check correct file format
						my $fileRef = $entryPrincipleFile_frame -> cget('-textvariable');
						my $samForReport = $$fileRef;
						
						die "Input file (set to \'$samForReport\') not found.\n\n" unless -e $samForReport;
						my @samTestResults = fileTest('SAM', $samForReport);
						print STDERR "\n\tINPUT file format test report \'SAM\': $samForReport\n\n\t\tSAM format ... $samTestResults[0]\n\t\tSAM read order ... $samTestResults[1]\n\t\tSAM chr grouping ... $samTestResults[3]\n\t\tSAM header ... $samTestResults[2]\n\n";
						die "sam file format for inputfile (\'$samForReport\') not recognised.\n\n"	if $samTestResults[0] eq 'BAD';
						die "sam file reads for inputfile (\'$samForReport\') appear disordered.\n\n"	if $samTestResults[1] eq 'BAD';
						die "sam file chromosomes for inputfile (\'$samForReport\') appear disordered.\n\n"	if $samTestResults[3] eq 'BAD';
						
						$text_frameScreen -> update();
						
						my $blueFileRef = $entry_Optional_frame -> cget('-textvariable');
						my $bluePrintFile = $$blueFileRef;
						$bluePrintFile = 'NOT SELECTED' if $bluePrintFile eq '';
						die "Blueprint file (set to \'$bluePrintFile\') not found.\n\n" if ((!-e $bluePrintFile) && ($bluePrintFile ne 'NOT SELECTED'));

						if (($bluePrintFile =~ /\w/) && ($bluePrintFile ne 'NOT SELECTED'))
							{
								my @bedTestResults = fileTest('BED', $bluePrintFile);
								print STDERR "\n\tBLUEPRINT file format test report \'BED\': $bluePrintFile\n\n\t\tBED format ... $bedTestResults[0]\n\n";
								die "bed file format for inputfile (\'$bluePrintFile\') not recognised.\n\n"	if $bedTestResults[0] eq 'BAD';
							}
					
						$closedAndOpen = "YES" if ((-e $bluePrintFile) && ($bluePrintFile ne 'NOT SELECTED') && ($bluePrintFile ne ''));
						
						my $genomeSizeFileRef = $entrygenomeSize_frame -> cget('-textvariable');
						my $genomeSizeFile = $$genomeSizeFileRef;
						$genomeSizeFile = '' unless defined $genomeSizeFile;
						die "chromosome size file (set to \'$genomeSizeFile\') required but not found.\n\n" unless ((defined $genomeSizeFile) && (-e $genomeSizeFile));	
						my @genomeTestResults = fileTest('CHROM', $genomeSizeFile);
						print STDERR "\n\tchromosome size file format test report \'CHROM\': $genomeSizeFile\n\n\t\tCHROM format ... $genomeTestResults[0]\n\n";
						die "chromosome size file format for inputfile (\'$genomeSizeFile\') not recognised.\n\n"	if $genomeTestResults[0] eq 'BAD';
						
						my $peakBinSize = $entry_VarOne_Options_PeakCall -> cget('-textvariable');
						my $backgroundBinSize = $entry_VarTwo_Options_PeakCall -> cget('-textvariable');
						my $stepSize = $entry_VarThree_Options_PeakCall -> cget('-textvariable');
						my $thresholdSignificanceLevel = $entry_VarFour_Options_PeakCall -> cget('-textvariable');
						my $peaksForBackgroundCalc = $entry_VarFive_Options_PeakCall -> cget('-textvariable');
						my $flatThreshold = $entry_VarSix_Options_PeakCall -> cget('-textvariable');
						my $maxPeakPValue = $radio_VarSeven_frameOptions_PeakCall_ON -> cget('-variable');
							$$maxPeakPValue = 'ON' unless $$maxPeakPValue eq 'OFF';

						$text_frameScreen -> update();
						$$flatThreshold = 'NONE' if $$flatThreshold eq '';
									
						#sets limits for assigned parameters
						die "peak bin size (set to \'$$peakBinSize\') must be a positive integer.\n\n" unless (($$peakBinSize !~ /[^0-9\.]/) && (fmod($$peakBinSize,1) == 0) && ($$peakBinSize > 0)); 
						die "background bin size (set to \'$$backgroundBinSize\') must be a positive integer.\n\n" unless (($$backgroundBinSize !~ /[^0-9\.]/) && (fmod($$backgroundBinSize,1) == 0) && ($$backgroundBinSize > 0));  
						die "step size (set to \'$$stepSize\') must be a positive integer.\n\n" unless (($$stepSize !~ /[^0-9\.]/) && (fmod($$stepSize,1) == 0) && ($$stepSize > 0)); 
						die "number of peaks for background sampling (set to \'$$peaksForBackgroundCalc\') must be a positive integer.\n\n" unless (($$peaksForBackgroundCalc !~ /[^0-9\.]/) && (fmod($$peaksForBackgroundCalc,1) == 0) && ($$peaksForBackgroundCalc > 0)); 
						die "flat threshold (set to \'$$flatThreshold\') must be 'NONE' or a non-negative number.\n\n" unless ((($$flatThreshold !~ /[^0-9\.]/) && ($$flatThreshold >= 0)) || ($$flatThreshold eq 'NONE')); 
						die "threshold significance level (set to \'$$thresholdSignificanceLevel\') must be in the range [0 .. 1].\n\n" unless (($$thresholdSignificanceLevel >= 0) && ($$thresholdSignificanceLevel <= 1)); 

						die "background bin size (set to \'$$backgroundBinSize\') must be greater than peak bin size (set to \'$$peakBinSize\').\n\n" if $$backgroundBinSize < $$peakBinSize; 
										
						#executes subroutine	 

						print STDERR "\n\tPeak Caller v1.1.\n\n \twith parameters:\n\n\t\tinput sam file: $samForReport\n\t\toutput bed file:  $OutPutFile\n\t\tchromosome size file: $genomeSizeFile\n\t\tblueprint file: $bluePrintFile\n\n\t\tbin size/background size: $$peakBinSize/$$backgroundBinSize\n\t\tpeak target for threshold/binscore assessment: $$peaksForBackgroundCalc\n\t\tcalculated peak threshold significance: $$thresholdSignificanceLevel\n\t\tstep size: $$stepSize\n\t\tflat threshold: $$flatThreshold\n\t\tpeak score p values: $$maxPeakPValue\n\n";
						$text_frameScreen -> update();
						# threshold value contains the threshold\tpValueHashref;
						disableAllWidgets ();
						my @thresholdValue = threshold($samForReport, $bluePrintFile, ${$peakBinSize}, $$backgroundBinSize, $$peaksForBackgroundCalc, $genomeSizeFile, $$thresholdSignificanceLevel, $closedAndOpen, $$flatThreshold, $$maxPeakPValue); #if $flatThreshold eq "NONE";### <- need to add powerDigit to subroutine
						$thresholdValue[0] = $$flatThreshold if $$flatThreshold ne 'NONE';
						peakCall($samForReport, $thresholdValue[0], $$peakBinSize, $$backgroundBinSize, $genomeSizeFile, $$stepSize, $thresholdValue[1], $$maxPeakPValue);
						
						endRunOrAbort();
					}

				if ($option eq 'DensityAnalyser')
					{

						my $fileRef = $entryPrincipleFile_frame -> cget('-textvariable');
						my $samForDensity = $$fileRef;
						die "Input file (set to \'$samForDensity\') not found.\n\n" unless -e $samForDensity;
						
						my @samTestResults = fileTest('SAM', $samForDensity);
						print STDERR "\n\tINPUT file format test report \'SAM\': $samForDensity\n\n\t\tSAM format ... $samTestResults[0]\n\t\tSAM read order ... $samTestResults[1]\n\t\tSAM chr grouping ... $samTestResults[3]\n\t\tSAM header ... $samTestResults[2]\n\n";
						die "sam file format for inputfile (\'$samForDensity\') not recognised.\n\n"	if $samTestResults[0] eq 'BAD';
						die "sam file reads for inputfile (\'$samForDensity\') appear disordered.\n\n"	if $samTestResults[1] eq 'BAD';
						die "sam file chromosomes for inputfile (\'$samForDensity\') appear disordered.\n\n"	if $samTestResults[3] eq 'BAD';

						# checks that -g has been set (mandatory)
						my $genomeSizeFileRef = $entrygenomeSize_frame -> cget('-textvariable');
						my $genomeSizeFile = $$genomeSizeFileRef;
						$genomeSizeFile = '' unless defined $genomeSizeFile;
						die "chromosome size file (set to \'$genomeSizeFile\') required but not found.\n\n" unless ((defined $genomeSizeFile) && (-e $genomeSizeFile));	
						my @genomeTestResults = fileTest('CHROM', $genomeSizeFile);
						print STDERR "\n\tchromosome size file format test report \'CHROM\': $genomeSizeFile\n\n\t\tCHROM format ... $genomeTestResults[0]\n\n";
						die "chromosome size file format for inputfile (\'$genomeSizeFile\') not recognised.\n\n"	if $genomeTestResults[0] eq 'BAD';

						#assign variables and delete from %arguments hash
						my $thresh = $entry_VarFour_Options_DensityAnalyzer -> cget('-textvariable');
						my $maxThresh =$entry_VarFive_Options_DensityAnalyzer -> cget('-textvariable');
						my $tail = $entry_VarOne_Options_DensityAnalyzer -> cget('-textvariable');
						my $sigma = $entry_VarThree_Options_DensityAnalyzer -> cget('-textvariable');
						my $stepSize = $entry_VarTwo_Options_DensityAnalyzer -> cget('-textvariable');
						my $offSet = $entry_VarSix_Options_DensityAnalyzer -> cget('-textvariable');
						
						#sets limits for assigned parameters
						die "minimum bin threshold (set to \'$$thresh\') be 'DEFAULT' or a non-negative integer.\n\n" unless ((($$thresh !~ /[^0-9\.]/) && (fmod($$thresh,1) == 0) && ($$thresh >= 0)) || ($$thresh eq 'DEFAULT')); 
						die "maximum bin threshold (set to \'$$maxThresh\') be a positive integer.\n\n" unless (($$maxThresh !~ /[^0-9\.]/) && (fmod($$maxThresh,1) == 0) && ($$maxThresh > 0)); 
						die "tailSize must (set to \'$$tail\') be a positive integer.\n\n" unless (($$tail !~ /[^0-9\.]/) && (fmod($$tail,1) == 0) && ($$tail > 0)); 
						die "sigma must (set to \'$$sigma\') be a positive integer.\n\n" unless (($$sigma !~ /[^0-9\.]/) && (fmod($$sigma,1) == 0) && ($$sigma > 0)); 
						die "step size must (set to \'$$stepSize\') be a positive integer.\n\n" unless (($$stepSize !~ /[^0-9\.]/) && (fmod($$stepSize,1) == 0) && ($$stepSize > 0)); 
						die "offset must (set to \'$$offSet\') be an integer.\n\n" unless (($$offSet !~ /[^0-9\.-]/) && (fmod($$offSet,1) == 0));

						my $binSize = $$tail*2;
						#executes subroutine	 
						print STDERR "\n\tDensity Analyzer v1.0.\n\n\twith parameters: \n\n\t\tinput file: $samForDensity\n\t\tchromomosome size file: $genomeSizeFile\n\n\t\tstep size: $$stepSize\n\t\ttail length: $$tail\n\t\tsigma: $$sigma\n\t\tminimum bin threshold: $$thresh\n\t\tmaximum bin threshold: $$maxThresh\n\t\ttrack offset: $$offSet\n\t\tbin size: $binSize\n\n";
						$text_frameScreen -> update();
						disableAllWidgets ();
						densityAnalyzer($samForDensity, $$stepSize, $$tail, $$sigma, $$thresh, $$offSet, $$maxThresh, $genomeSizeFile);
						endRunOrAbort();


					}
				if ($option eq 'SAMFilter')
					{
						my $fileRef = $entryPrincipleFile_frame -> cget('-textvariable');
						my $samForFilter = $$fileRef;
						my $samForHeaderRef = $entry_Optional_frame -> cget('-textvariable');
						my $samForHeader = $$samForHeaderRef;
						
						$samForHeader = $samForFilter if (($samForHeader eq 'NOT SELECTED') || ($samForHeader eq ''));
						
						die "Input file (set to \'$samForFilter\') not found.\n\n" unless -e $samForFilter;
						my @samTestResults = fileTest('SAM', $samForFilter);
						print STDERR "\n\tINPUT file format test report \'SAM\': $samForFilter\n\n\t\tSAM format ... $samTestResults[0]\n\t\tSAM read order ... $samTestResults[1]\n\t\tSAM chr grouping ... $samTestResults[3]\n\t\tSAM header ... $samTestResults[2]\n\n";
						die "sam file format for inputfile (\'$samForFilter\') not recognised.\n\n"	if $samTestResults[0] eq 'BAD';
						die "sam file reads for inputfile (\'$samForFilter\') appear disordered.\n\n"	if $samTestResults[1] eq 'BAD';
						print STDERR "warning: sam file chromosomes for inputfile (\'$samForFilter\') appear disordered.\n\n"	if $samTestResults[3] eq 'BAD';

						if ($samForHeader ne $samForFilter)
							{
								die "Optional header file (set to \'$samForHeader\') not found.\n\n" unless -e $samForHeader;
								@samTestResults = fileTest('SAM', $samForHeader);
								print STDERR "\n\tOPTIONAL HEADER file format test report \'SAM\': $samForHeader\n\n\t\tSAM format ... $samTestResults[0]\n\t\tSAM read order ... $samTestResults[1]\n\t\tSAM chr grouping ... $samTestResults[3]\n\t\tSAM header ... $samTestResults[2]\n\n";
								print STDERR "\twarning: sam file composition for optional header file (\'$samForHeader\') is disordered.\n"	if (($samTestResults[0] eq 'BAD') || ($samTestResults[1] eq 'BAD') || ($samTestResults[3] eq 'BAD'));
								die "no sam file header detected in optional header file (set to \'$samForHeader \')\n\n" if $samTestResults[2] eq 'NONE';
							}

						# checks that -g has been set (mandatory)
						my $genomeSizeFileRef = $entrygenomeSize_frame -> cget('-textvariable');
						my $genomeSizeFile = $$genomeSizeFileRef;
						$genomeSizeFile = '' unless defined $genomeSizeFile;
						die "chromosome size file (set to \'$genomeSizeFile\') required but not found.\n\n" unless ((defined $genomeSizeFile) && (-e $genomeSizeFile));	
						my @genomeTestResults = fileTest('CHROM', $genomeSizeFile);
						print STDERR "\n\tchromosome size file format test report \'CHROM\': $genomeSizeFile\n\n\t\tCHROM format ... $genomeTestResults[0]\n\n";
						die "chromosome size file format for inputfile (\'$genomeSizeFile\') not recognised.\n\n"	if $genomeTestResults[0] eq 'BAD';

						#assign variables and delete from %arguments hash
						my $mapqThresh = $entry_VarOne_Options_SAMFilter -> cget('-textvariable');
						my $uqThresh = $entry_VarTwo_Options_SAMFilter -> cget('-textvariable');

						my $pcrDuplicates = $radio_VarThree_Options_SAMFilter_ON -> cget('-variable');
							$$pcrDuplicates = 'ON' unless $$pcrDuplicates eq 'OFF';
						
						#sets limits for assigned parameters
						die "mapq threshold (set to \'$$mapqThresh\') must be a non-negative integer.\n\n" unless (($$mapqThresh !~ /[^0-9\.]/) && (fmod($$mapqThresh,1) == 0) && ($$mapqThresh >= 0)); 
						die "uq threshold (set to \'$$uqThresh\') must be a non-negative integer.\n\n" unless (($$uqThresh !~ /[^0-9\.]/) && (fmod($$uqThresh,1) == 0) && ($$uqThresh >= 0)); 
						die "PCR duplicates (set to \'$$pcrDuplicates\') can only have the values ON (remove PCR duplicates) or OFF (retain PCR duplicates).\n\n" if (($$pcrDuplicates ne "OFF") && ($$pcrDuplicates ne "ON")); 
						
						#executes subroutine	 
						print STDERR "\n\tSam Filter v1.0.\n\n\twith parameters:\n\n\t\tinput file: $samForFilter\n\n\t\tmapq threshold: $$mapqThresh\n\t\tuq threshold: $$uqThresh\n\t\tPCR duplicate removal: $$pcrDuplicates\n\n";
						$text_frameScreen -> update();
						disableAllWidgets ();
						samFilter($samForHeader, $samForFilter, $$mapqThresh, $$uqThresh, $$pcrDuplicates, $genomeSizeFile);#Next option here: 
						endRunOrAbort();
					}

				if ($option eq 'TopPeaks')
					{
						my $bedForTopRef = $entryPrincipleFile_frame -> cget('-textvariable');
						my $bedForTop = $$bedForTopRef;
						die "Input file (set to \'$bedForTop\') not found.\n\n" unless -e $bedForTop;

						my @bedTestResults = fileTest('BED', $bedForTop);
						print STDERR "\n\tINPUT file format test report \'BED\': $bedForTop\n\n\t\tBED format ... $bedTestResults[0]\n\n";
						die "bed file format for inputfile (\'$bedForTop\') not recognised.\n\n"	if $bedTestResults[0] eq 'BAD';
						
						#check correct file extension
						my @topPeaksTitleCheck = split(/\./, $bedForTop);
						die "Top Peak Selector requires *.bed file input\n\n" if $topPeaksTitleCheck[$#topPeaksTitleCheck] ne "bed";
								
						#assign variables and delete from %arguments hash
						my $topPeaksNumber = $entry_VarOne_Options_TopPeaks -> cget('-textvariable');
						
						#sets limits for assigned parameters()
						die "number of peaks (set to \'$$topPeaksNumber\') must be either 'ALL' or a positive integer. \n\n" unless ((($$topPeaksNumber !~ /[^0-9\.]/) && (fmod($$topPeaksNumber,1) == 0) && ($$topPeaksNumber >= 0)) ||  ($$topPeaksNumber eq 'ALL'));
						
						#executes subroutine	 
						print STDERR "\n\tTop Peak Selector v1.0\n\n\twith parameters:\n\n\t\tinput file: $bedForTop\n\t\ttarget number of reads: $$topPeaksNumber\n\n";
						$text_frameScreen -> update();
						disableAllWidgets ();
						topPeaks($bedForTop, $$topPeaksNumber);
						sleep (10);
						endRunOrAbort();
					}

				if ($option eq 'RandomSAMReadSelection')
					{
						my $RSnameRef = $entryPrincipleFile_frame -> cget('-textvariable');
						my $RSname = $$RSnameRef;
						die "Input file (set to \'$RSname\') not found.\n\n" unless -e $RSname;
						my @samTestResults = fileTest('SAM', $RSname);
						print STDERR "\n\tINPUT file format test report \'SAM\': $RSname\n\n\t\tSAM format ... $samTestResults[0]\n\t\tSAM read order ... $samTestResults[1]\n\t\tSAM chr grouping ... $samTestResults[3]\n\t\tSAM header ... $samTestResults[2]\n\n";
						die "sam file format for inputfile (\'$RSname\') not recognised.\n\n"	if $samTestResults[0] eq 'BAD';
						print STDERR "warning: sam file reads for inputfile (\'$RSname\') appear disordered.\n\n"	if $samTestResults[1] eq 'BAD';
						print STDERR "warning: sam file chromosomes for inputfile (\'$RSname\') appear disordered.\n\n"	if $samTestResults[3] eq 'BAD';

						my $RSnumber = $entry_VarOne_Options_RandomSAMReadSelection -> cget('-textvariable');
						die "number of reads (set to \'$$RSnumber\' must be a positive integer.\n\n" unless (($$RSnumber !~ /[^0-9\.]/) && (fmod($$RSnumber,1) == 0) && ($$RSnumber > 0)); 
						
						#executes subroutine	 
						print STDERR "\n\tRandom Sam Read Selection v1.0.\n\n\twith parameters: \n\n\t\toutput file name: $OutPutFile \n\t\tnumber of reads required: $$RSnumber\n\n";
						
						#executes subroutine	 
						$text_frameScreen -> update();
						disableAllWidgets ();
						randomReadSelection($RSname, $$RSnumber);
						endRunOrAbort();
					}

				if ($option eq 'NumericalSort')
					{
						my $samForNSortRef = $entryPrincipleFile_frame -> cget('-textvariable');
						my $samForNSort = $$samForNSortRef;
					
						die "Input file (set to \'$samForNSort\') not found.\n\n" unless -e $samForNSort;
						my @samTestResults = fileTest('SAM', $samForNSort);
						print STDERR "\n\tINPUT file format test report \'SAM\': $samForNSort\n\n\t\tSAM format ... $samTestResults[0]\n\t\tSAM read order ... $samTestResults[1]\n\t\tSAM chr grouping ... $samTestResults[3]\n\t\tSAM header ... $samTestResults[2]\n\n";
						die "sam file format for inputfile (\'$samForNSort\') not recognised.\n\n"	if $samTestResults[0] eq 'BAD';
						#check correct file extension
				
						#executes subroutine	 
						print STDERR "\n\tNumerical Sam Sort v1.0\n\n\twith parameters:\n\n\t\tinput file: $samForNSort\n\t\toutput file: $OutPutFile\n\n";
						$text_frameScreen -> update();
						disableAllWidgets ();
						samNSort($samForNSort);
						endRunOrAbort();
					}
				$buttonLogFile_frame -> configure(-state => 'normal');
			
		}

sub samNSort
	{
		my $file = $_[0];
		my @line = ();
		my %largeSORTHash = ();
		my $currentKey = 0;
		my $maxValue = 0;
		my $count =0;
		my $headerOff = 0;;
		my @headerCheckerArray; 		
		print STDERR "\tsorting $file...\n\n";
		$text_frameScreen -> update();
		 
		open (HASHSORT, "<", "$file") || die  "Unable to open $file\n\n";
		while (<HASHSORT>)
				{
					if ($headerOff == 0)
						{
							@headerCheckerArray = split("", $_);
							print $resultsOut "$_" if $headerCheckerArray[0] eq '@';
							$headerOff = 1 if $headerCheckerArray[0] ne '@';
						}
				
					if ($headerOff == 1)
						{
							@line = split(" ", $_);
							push @{$largeSORTHash{$line[3]}}, $_;
							$maxValue = $line[3] if $line[3] > $maxValue;
							$count += 1;
							if ($count%1000000 == 0)

								{
									print STDERR "\tcollected $count reads...\n";
									$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
								}
						}
				}
		my $number = keys %largeSORTHash;
		
		for ($currentKey = 0; $currentKey <= $maxValue; $currentKey += 1)
			{
				print $resultsOut @{$largeSORTHash{"$currentKey"}} if defined $largeSORTHash{"$currentKey"};
			}
		close $resultsOut;
		print STDERR "\n\tsorted.\n\n";
		$text_frameScreen -> update();
	}



sub randomReadSelection
	{
		my $file = $_[0];
		my $absoluteReadNumber = $_[1];
		my $counter = 0;
		my $numerator = 0;
		my $denominator = 0;
		my $percentage = 0;
		my $random = 0;
		my $check = 0;
		my $headerOff = 0;

		my @headerCheckerArray = ();

		print STDERR "\tcounting reads...\n";
		
		open (FILE, "<$file");
		while (<FILE>)
			{
				if ($headerOff == 0)
					{
						@headerCheckerArray = split("", $_);
						$headerOff = 1 if $headerCheckerArray[0] ne '@';
					}
				
				if ($headerOff ==1)
					{
						$counter += 1;
					}
			}
		close FILE;	
		
		$headerOff = 0;
		$percentage = ($absoluteReadNumber/$counter)*100;
		### more zeros gives more precision in estimation of numbers of reads to select.
		$numerator = int($percentage*10000);
		$denominator = 1000000;
		
		my $roundedPercent = sprintf("%.1f", $percentage);
		
		print STDERR "\tselecting ~$roundedPercent% of $counter reads...\n";
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
		open (FILE, "<", "$file") || die "Unable to open $file\n\n";;
		while (<FILE>)
			{
				if ($headerOff == 0)
					{
						@headerCheckerArray = split("", $_);
						print $resultsOut "$_" if $headerCheckerArray[0] eq '@';
						$headerOff = 1 if $headerCheckerArray[0] ne '@';
					}
				
				if ($headerOff ==1)
					{
						$random = int(rand(1000000));
						if ($random <= $numerator)
							{
								print $resultsOut "$_";
								$check += 1;
							}
					}
			}
			
		close FILE;
		close $resultsOut;
		print STDERR "\t$check reads randomly selected.\n\n";
		$text_frameScreen -> update();
	}

sub topPeaks
	{
		my $file = $_[0];
		my $numberToPrint = $_[1];
		my @line = ();
		my %largeSORTHash = ();
		my $tempCounter = 0;
		my @orderedArray;
		my $counter = 0;
		my @individualArray;
		my @totalArray;
		my $x;
		my $limit;
		
		print STDERR "\tsorting $numberToPrint peaks in $file...\n\n";

		$text_frameScreen -> update();
		open (HASHSORT, "<", "$file") || die  "Unable to open $file\n\n";;
		while (<HASHSORT>)
				{
					@line = split(" ", $_);
					push (@{$largeSORTHash{$line[4]}}, $_);
				}
		close HASHSORT;
		
		foreach my $key (reverse sort {$a <=> $b} keys %largeSORTHash) 
			{
				push (@orderedArray,  "@{$largeSORTHash{$key}}");
				$counter += 1;
			}
		
		for (@orderedArray)
			{
				@individualArray = split("\n", $_);
				for (@individualArray)
					{
						$_ =~ s/^\s//; 
						push (@totalArray, $_);
					}
			}
		my $count = @totalArray;
		$limit = $numberToPrint;
		$limit = $count if $numberToPrint eq 'ALL';
		for ($x = 0; $x < $limit; $x += 1)
			{
				print $resultsOut "$totalArray[$x]\n";
			}

		close $resultsOut;
		print STDERR "\tsorted.\n\n";
		return;
	}

sub samFilter
	{
		### ****simplified from standalone
		#stamp package: for header detail
				
		# ** HCS denotes ordering as per $genomeSizeFile, and requires $genomeSizeFile to function
		###	
		# access $genomeSizeFile to get new order for sorted file
		# write comment line to start of new sorted sam file
		# option to INCLUDE header from alternate sam file
		# if sam header is present, write it to new sorted file
		# if sam header absent, or present, add new @SQ lines
				
		#	takes a mapped unsorted sam file that has been sorted by chromosome position with unix command:
		#
		#	sort -n --key=4,5 filename.sam > sortedFilename.sam
		#	
		#		and prints the header from the unsorted filename to the new filtered sam file, but orders the chromosomes as they appear in $genomeSizeFile
		
		#		new @SQ tags are added (in addition to original stampy @SQ tags) to denote the new order of chromosomes.		
		
		my $headerFile = $_[0];
		my $sortedFile = $_[1];
		
		$headerFile = $sortedFile if $headerFile eq 'NOT SELECTED';
		
		my $mapq = $_[2];
		my $uq = $_[3];
		my $pcrDuplicates = $_[4];
		my $genomeSizeFile = $_[5];

		my $currentTempFile = 0;
		my $headerOff = 0;
		my @headerCheckerArray = ();	
		my @splitArray = ();
		my @currentUQArray = ();		
		
		my $passedFilter = 0;
		my $totalReads = 0;
		my $i = 0;
		my $percentagePassedFilter = 0;
		my $numberOfChromosomes = 0;
		my $tempSwitch = 0;
		my $unmappedCount = 0;
		my $percentageUnmapped = 0;
		
		my $chromCount = 0;
		my @chromNames = ();
		my @chromSizes = ();
		my @line = ();
		my %chromReadCount = ();
		my $headOne = 0;
		my $samHeader = "FALSE";
		my $percentageDuplicates = 0;
		my $testString = 0;
		my $oldTestString = 0;
		my $duplicateCount = 0;
		
				
		print $resultsOut "\@CO\ttime:$timeString\tprog:$0\tuser:$user\tcwd:$dir\tmapq:$mapq\tuq:$uq\n"; #inserts new header comment line with current additional details
		open(HEADERFILE, "<", "$headerFile") || die  "Unable to open $headerFile\n\n";
		while (<HEADERFILE>) # then prints remainder of original header and stops at with first non-header line
			{
				@splitArray = split("", $_);
				if ($splitArray[0] eq '@')
					{
						$samHeader = "TRUE";
						print $resultsOut "$_";
					}
				else {last;}
					
			}
		close HEADERFILE;
		
		print STDERR "\tsam header detected, original header transferred to new file. \n" if $samHeader eq "TRUE"; #confirms status of header
		print STDERR "\twarning: sam header not detected!\n" if $samHeader eq "FALSE";
		$text_frameScreen -> update();
		# create new @SQ tags in the order of $genomeSizeFile. These tags are indicated by @SQ\tSNN:<chrom.name>:hg19ChromSize\tLN:<chrom.size>. The ultrafiltered sam file will be made in this order
		print STDERR "\tcreating chromosome order list from $genomeSizeFile...\n";
		$text_frameScreen -> update();
		open (CHROMSIZES, "<", "$genomeSizeFile") || die  "Unable to open $genomeSizeFile\n\n";
		while (<CHROMSIZES>)
			{
				
				@line = split(" ", $_);
				push (@chromNames, "$line[0]");
				push (@chromSizes,  "$line[1]");
			}
			
		# initialise chromosome passed filter counts hash with zero value for each:
		for ($i = 0; $i < @chromNames; $i += 1)
			{
				$chromReadCount{$chromNames["$i"]} = 0;
			}
		
		$currentTempFile = "$headerFile" . ".temp";
		my $alternateTempFile = "$headerFile" . ".alt.temp";
		@tempFileList = ($currentTempFile, $alternateTempFile);

		
		# makes a new temporary file containing only reads that pass the mapq and uq filters
		print STDERR "\tundertaking initial mapq (and uq) filtering...\n";
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
		open (SORTEDINPUT, "<", "$sortedFile") || die  "Unable to open $sortedFile\n\n";
		open (TEMP, ">", "$currentTempFile") || die  "Unable to open $currentTempFile\n\n";
		
		my %presentChroms = ();
		my @chromsToPrint = (); 
		my @testChroms = ();
		my $uqOn = 0;
		
		while (<SORTEDINPUT>)
			{
				if ($headerOff == 0)
					{
						@headerCheckerArray = split("", $_);
						$headerOff = 1 if $headerCheckerArray[0] ne '@';
					}
				
				if ($headerOff ==1)
					{
						@splitArray = split(" ", $_);
						
						if (($totalReads ==0) && ($splitArray[11] =~ /UQ/i))
							{
								print STDERR "\tUQ tags detected.\n\n";
								$uqOn = 1;
							}

						if ($pcrDuplicates eq "ON") # next seven lines added 20130507 to put in PCR duplicate checker
							{
								$oldTestString = $testString;
								$testString = "$splitArray[2]"."$splitArray[3]"."$splitArray[4]"."$splitArray[8]";
								$duplicateCount += 1 if $testString eq $oldTestString;
								next if $testString eq $oldTestString;
							}
						
						$unmappedCount += 1 if $splitArray[3] == 0;
						if ($splitArray[3] > 0)
							{
								if ($uqOn == 1)
									{
										@currentUQArray = split(":", $splitArray[11]);
										if (($splitArray[4] >= $mapq) && ($currentUQArray[2] <= $uq))  
											{
												$presentChroms{"$splitArray[2]"} = 0 unless exists $presentChroms{"$splitArray[2]"}; #makes a hash containing as keys all chromosome names presnt
												print TEMP "$_";
												$passedFilter += 1;
												$chromReadCount{$splitArray[2]} += 1;
											}
									}

								if ($uqOn == 0)
									{
										
										if ($splitArray[4] >= $mapq)  
											{
												$presentChroms{"$splitArray[2]"} = 0 unless exists $presentChroms{"$splitArray[2]"}; #makes a hash containing as keys all chromosome names presnt
												print TEMP "$_";
												$passedFilter += 1;
												$chromReadCount{$splitArray[2]} += 1;
											}
									}
							}
						$totalReads += 1;
					}		
			}
		close SORTEDINPUT;
		close TEMP;
		
		@testChroms = %presentChroms; # makes an array of chromosomes that have been found in the file
		for ($i = 0; $i < @chromNames; $i += 1) # adds to a new array chromosomes found in the file, in the order they appear in the chrom.sizes file
			{
				push (@chromsToPrint, "$chromNames[$i]") if exists $presentChroms{"$chromNames[$i]"};
			}
				
		# adding @SQ lines to sorted sam header that contain number of reads that have passed the filters	
		my $accuratePercent = $passedFilter/$totalReads*100;
		$accuratePercent = sprintf("%.2f", $accuratePercent);
		
		for ($chromCount = 0; $chromCount < @chromNames; $chromCount += 1)
			{
				print $resultsOut "\@SQ\tSN:$chromNames[$chromCount]:readsPassedFilter:$chromReadCount{$chromNames[$chromCount]}\tLN:$chromSizes[$chromCount]\n";
			}
		
		print $resultsOut "\@CO\ttotalReads:$totalReads\treadsPassedFilter:$passedFilter\t percentPassed:$accuratePercent%\tmapQpoint:$mapq\tUQpoint:$uq\n";
		print STDERR "\tnew header completed.\n\n\tbeginning ordering of chromosomes...\n\n";
		$text_frameScreen -> update();
		## this is the ordering section		
		my $readFile;
		my $writeFile;
		
		$numberOfChromosomes = @chromsToPrint;
		for ($i = 0; $i < $numberOfChromosomes; $i += 1)
			{
					print STDERR "\tsorting $chromsToPrint[$i]...\n";
					$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;

					if ($i%2 == 0)
						{
							$readFile = $currentTempFile;
							$writeFile = $alternateTempFile;
						}
					if ($i%2 == 1)
						{
							$readFile = $alternateTempFile;
							$writeFile = $currentTempFile;
						}
					open (my $read, "<", "$readFile") || die  "Unable to open $readFile\n\n";
					open (my $write, ">", "$writeFile") || die  "Unable to open $writeFile\n\n";
					while (<$read>)
							{
								print $resultsOut "$_" if ($_ =~ m#\b$chromsToPrint[$i]\b#);
								print $write "$_" if ($_ !~ m#\b$chromsToPrint[$i]\b#);

							}
	
					close $read;
					close $write;
			}
		
		unlink $currentTempFile;
		unlink $alternateTempFile;
				
		$percentagePassedFilter = ($passedFilter/$totalReads)*100;
		$percentageUnmapped = ($unmappedCount/$totalReads)*100;
		$percentagePassedFilter = sprintf("%.2f", $percentagePassedFilter);
		$percentageUnmapped = sprintf("%.2f", $percentageUnmapped);
		$percentageDuplicates = ($duplicateCount/$totalReads)*100;
		$percentageDuplicates = sprintf("%.2f", $percentageDuplicates);


		print STDERR "\n\t$percentageUnmapped% of total reads were unmapped.\n";
		print STDERR "\t$duplicateCount PCR duplicates ($percentageDuplicates% of total) were removed.\n" if $pcrDuplicates eq "ON";
		print STDERR "\t$passedFilter (~$percentagePassedFilter%) reads of total $totalReads successfully passed filter.\n\n";
		close $resultsOut;
		$text_frameScreen -> update();
	}	
	

sub densityAnalyzer
	{
		
		#removed requirement for HCS passed filter
		my $filename = $_[0];
		my $stepSizeSubDR = $_[1];
		my $tailSubDR = $_[2];
		our $sigmaSubDR = $_[3];
		my $threshSubDR = $_[4];
		my $offSetSubDR = $_[5];
		my $maxThreshSubDR = $_[6];
		my $genomeSizeFile = $_[7];
		my $bandWidth = $tailSubDR*2 +1;
		my $binSize = $tailSubDR*2 +1;
		my $span = $stepSizeSubDR;
		my $gaussCount = 0;
		my $headerLineCheckerOff = 0;
		my $currentBinStart = 0;
		my $currentBinEnd = 0;
		my $positionCount = 0;
		my $i = 0;
		my $offStart;
		my $offEnd;
		my $chromosome = 0;
		my $startString = 1;
		my $binScore = 0;
		my $arraySize = 0;
		my $chromosomeSize = 0;
		my $headerSwitch = 0;
		my $gaussOutput = 0;
		my $memSaverGauss = 0;
		my $sum = 0;
		my $roundedFigure = 0;
		my $gapCount = 0;

		
		my($stub, $directories, $suffix) = fileparse($filename);

		#my $stub = $filename;chomp $stub;for ($i = 0; $i < 4; $i += 1){chop $stub;}
		my $trackName = "$stub.step$stepSizeSubDR.tail$tailSubDR.sig$sigmaSubDR.thresh$threshSubDR.off$offSetSubDR";
		my $trackDescription = "$stub" . "-$stepSizeSubDR.$tailSubDR.$sigmaSubDR.$threshSubDR.$offSetSubDR" . "-";
		
		my @currentLineSplit = ();
		my @readStartPositionArray = ();
		my @headerCheck = ();
		my @splitArray = ();
		my @gaussArray = ();
		our @fixedGaussArray = ();
		my @gaussSubArray = ();
		
		# generates the gaussian values based on sigma and tailsize; eg for tail of 150, 301 values are generated and placed in the fixedGauss reference array
		for ($i = -$tailSubDR; $i <= $tailSubDR; $i += 1)
				{
					$gaussOutput = $sigmaSubDR*gaussEngine($i, $sigmaSubDR);
					push(@fixedGaussArray, $gaussOutput);

				}
			
			$text_frameScreen -> update();
		
		# if thresh is not set by user, calculates default bin thresh # HERE (moved lines 1750-1758 up)
		my %hashChromSizes = ();
		open (CHROMSIZE, "<$genomeSizeFile");
		while (<CHROMSIZE>)
			{
				chomp;
				my ($keyChromName, $valChromSize) = split /\t/;
				$hashChromSizes{$keyChromName} = $valChromSize; 
			}
		close CHROMSIZE;

		# if ($threshSubDR eq "DEFAULT") # HERE
		# 	{	# HERE
		my $threshCalcHeaderOff = 0; #<-removed == from here 20130703
		my $threshCalcReadCount = 0;
		my @threshCalcHeader = ();
		my $availableBaseCount = 0;
		print STDERR "\tcalculating default minimum bin threshold...\n"; # HERE
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
		$genomeBaseCount = baseCountGenomeSizeFile($genomeSizeFile);
		my %chromsPresent;
		open (THRESHCALC, "<$filename");
		while (<THRESHCALC>) 
			{
				if ($threshCalcHeaderOff == 0)
					{
						@threshCalcHeader = split("", $_);
						$threshCalcHeaderOff = 1 if $threshCalcHeader[0] ne "@";
						next if $threshCalcHeaderOff == 0;
					}
				my $lineChrom = $1 if $_ =~ /(\bchr\w*\b)/; # HERE
				$availableBaseCount = $availableBaseCount + $hashChromSizes{$lineChrom} unless defined $chromsPresent{$lineChrom};
				$chromsPresent{$lineChrom} = 1 if defined $hashChromSizes{$lineChrom}; # HERE
				#print STDERR "$lineChrom\n" if defined $hashChromSizes{$lineChrom};  # HERE
				$threshCalcReadCount += 1 if defined $hashChromSizes{$lineChrom}; # HERE
			}
		die "none of the chromosomes listed in $genomeSizeFile have been detected in $filename.\n\n" unless scalar keys %chromsPresent >= 1;
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
		my $threshSetting = $threshSubDR; # HERE
		my $threshCalced = 2*(($threshCalcReadCount/$availableBaseCount)*$binSize);# HERE
		$threshCalced = sprintf("%.0f", $threshCalced); # HERE
		$threshSubDR = $threshCalced if $threshCalced eq "DEFAULT"; # HERE
		$threshSubDR = sprintf("%.0f", $threshSubDR) if $threshSubDR ne "DEFAULT";
		print STDERR "\tgenome size file: $genomeSizeFile\n\tgenome total size: $genomeBaseCount\n\tavailable bases: $availableBaseCount\n\ttotal number of reads: $threshCalcReadCount\n"; # HERE
		print STDERR "\tdefault calculated minimum bin threshold: $threshCalced\n\n"; # HERE
		print STDERR "\tusing assigned threshold: $threshSubDR\n\n" if $threshSetting ne "DEFAULT"; # HERE
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
			#} # HERE
		
		### print wig header in new wig file
		print $resultsOut "track type=wiggle_0 name=$trackName description=$trackDescription viewLimits=0:500 autoScale=off gridDefault=on color=0,160,255 maxHeightPixels=60:60:11 visibility=full windowingFunction=mean+whiskers\n";
		
		###start of density track making
		open (ORIGINALSAM, "<", "$filename") || die  "Unable to open $filename\n\n";
		while (<ORIGINALSAM>)
			{
				#print "$_";
				if ($headerLineCheckerOff == 0)
					{
						
						@headerCheck = split("", $_);
						$headerLineCheckerOff = 1 if $headerCheck[0] ne "@";
						next if $headerLineCheckerOff == 0;
					}
				
				#from HERE
				next unless ($_ =~ /\b(chr\w*)\b\t\b(\w*)\b/);
						my $thisChrom = $1;
						my $thisPos = $2;
						next unless exists $hashChromSizes{$thisChrom};
				#@currentLineSplit = split(" ", $_);
											
				if ("$thisChrom" ne "$chromosome")
					{			
						$chromosome = "$thisChrom";
						#next unless exists $hashChromSizes{$chromosome};
						$chromosomeSize = $hashChromSizes{$chromosome};
											
						print STDERR "\tmaking density track for $chromosome...\n"; # HERE
						$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
						
						$currentBinStart = $startString; #+ $offSetSubDR;
						$currentBinEnd = $currentBinStart + $binSize;
						@readStartPositionArray = ();
						@gaussArray = ();
						$positionCount = 0;
						$gapCount = 1;
					}
			
					#where the peak calling is decided:
					push(@readStartPositionArray, $thisPos);
					$offEnd = $currentBinEnd + $offSetSubDR;
					while (("$thisPos" > "$currentBinEnd") && ($offEnd < $chromosomeSize ))
						{	
							while ($readStartPositionArray[0]<$currentBinStart)
								{
									shift(@readStartPositionArray);
								}
			
							$arraySize = @readStartPositionArray;
							for ($i = 0; $i < "$arraySize"; $i += 1)
								{
									if (($readStartPositionArray[$i] >= $currentBinStart) && ($readStartPositionArray[$i] < $currentBinEnd) && ($currentBinStart < $currentBinEnd))
										{
												$binScore += 1;
										}
								}
											
							if (($binScore > $threshSubDR) && ($binScore <= $maxThreshSubDR))
								{
									for ($gaussCount = 0; $gaussCount < $bandWidth; $gaussCount += 1)
										{
											$gaussArray[$gaussCount] = 0 if !defined $gaussArray[$gaussCount];
											$gaussArray[$gaussCount] += $binScore*$fixedGaussArray[$gaussCount] if ((defined $gaussArray[$gaussCount]) && (defined $fixedGaussArray[$gaussCount]));
										}
								}
												
							@gaussSubArray = splice(@gaussArray, 0, "$stepSizeSubDR");
							
							$sum += $_ for (@gaussSubArray);
							$roundedFigure = int(10*$sum);
							
							if ($roundedFigure == 0)
								{
									$gapCount = 1;
									@gaussArray = ();
								}
							
							if (($roundedFigure >0) && ($gapCount == 0))
								{
									for ($gaussCount = 0; $gaussCount < $stepSizeSubDR; $gaussCount += 1)
										{
											if (defined $gaussSubArray[$gaussCount])
												{
													$memSaverGauss = int(10*$gaussSubArray[$gaussCount]);
													print $resultsOut "$memSaverGauss\n" if $offStart > 0;
												}
											
										}
								}
							
							if (($roundedFigure > 0) && ($gapCount > 0))
								{
									#$newPosition = $startString + $positionCount*$stepSizeSubDR;
									$offStart = $currentBinStart + $offSetSubDR;
									if ($offStart >0)
										{
											print $resultsOut "fixedStep chrom=$chromosome start=$offStart step=1\n";
											
											for ($gaussCount = 0; $gaussCount < $stepSizeSubDR; $gaussCount += 1)
												{
													if (defined $gaussSubArray[$gaussCount])
														{
															$memSaverGauss = int(10*$gaussSubArray[$gaussCount]);
															print $resultsOut "$memSaverGauss\n";
														}
												}
										}
									$gapCount = 0;
								}
							
							$sum = 0;			
							$positionCount += 1;
							$currentBinStart += "$stepSizeSubDR";
							$currentBinEnd += "$stepSizeSubDR";

							$binScore = 0;                 
						}
			}
		close ORIGINALSAM;
		close $resultsOut;
		print STDERR "\n\tDensity track created.\n\n";
		$text_frameScreen -> update();
	}
sub baseCountGenomeSizeFile
	{	
		my $gSizeFile = $_[0];
		my $gTotalSize = 0;
		my @gline = ();
		open (GSIZE, "<", "$gSizeFile") || die  "Unable to open $gSizeFile\n\n";
		
		while (<GSIZE>)
			{
				@gline = split(" ", $_);
				$gTotalSize += $gline[1];
			}
		return $gTotalSize;
	}
				
sub gaussEngine
	{		
		my $in = $_[0];
		my $sigma = $_[1];
		my $denominator = 1/sqrt(2*3.14159265*$sigma**2);
		my $sigmaSubGEsquaredTwice = ($sigma*$sigma)*2;
		my $power = -($in**2)/$sigmaSubGEsquaredTwice;
		my $eToPower = 2.7182818284590451**$power;
		my $gaussed= $eToPower*$denominator;
		my $roundGaussed = sprintf("%.5f", $gaussed);
		return $roundGaussed;
	}


sub threshold 
	{
		my $samForAnalysis = $_[0];
		my $bluePrint = $_[1];
		my $halfRegionSize = ($_[2])/2;
		my $halfBackgroundSize = ($_[3])/2;
		my $Size = $_[2];
		my $peakBinSize = $Size;
		my $numberOfPeaks = $_[4]; # the number of sites used to calculate p value: default 10000; probably won't give option to change this.
		my $genomeSizeFile = $_[5];
		my $thresholdSignificanceLevel = $_[6];
		my $closedAndOpen = $_[7];
		my $flatThreshold = $_[8];
		my $maxPeakPValue =  $_[9];
		my @wholeBlue = ();
		
		my $index = 0;
		my $open = 0;
		
		my $closed = 0;
		my $x = 0;
		my $range = 0;

		my %closedChrom = ();
		my %openChrom = ();
		
		my @closedChromArray = ();
		my @openChromArray = ();
		
		my @line = ();
		my $siteLine = 0;
		my @globalSelection = ();
		my $key = 0;
		my $count = 0;
		my $subRange = 0;
		my $readName = 0;
		my $thresholdFromThreshold = 0;

		my $start = 0;
		my $end = 0;
		my @chromLine = ();
		my @chromName = ();
		my @chromStart = ();
		my @chromEnd = ();

		my $total = 0;
		my $chromCount = 0;
		
		my $randomPeakNumber = 0;
		my $randomPeakStart = 0;
		my $randomPeakEnd = 0;
		my $randomPeakString = 0;
		my $chrom = 0;
		my @randomChromArray = ();

		my $randomRef = 0;
		
		my %randomChromHash = ();
		my $randomStringData = 0;
		my @random = ();
		
		my $randomReadsPerBin = ();
		my $randomPeaksCompleted = ();

		my $openRef = 0;
		
		my $openStringData = 0;
		my @open = ();
		
		my $openReadsPerBin = ();
		my $openPeaksAssessed = ();

		my $closedRef = 0;
		
		my $closedStringData = 0;
		my @closed = ();
		
		my $closedReadsPerBin = ();
		my $closedPeaksCompleted = ();

		my $pValueTableRef;
		my $numberDataSetsPerPeak = 60;
		my $closedCount = 0;
		my $openCount = 0;
		my $costaCounter = 0;
		my $sum = 0;
		my @blueLine = ();
		
		my @openOnes;
		my @closedOnes;

		
		if ($closedAndOpen eq "YES")
			{
				open (BLUE, "<", "$bluePrint") || die  "Unable to open $bluePrint\n\n";
				print STDERR "\treading blueprint file ($bluePrint)...\n\n";
				$text_frameScreen -> update();
				while (<BLUE>)
					{
						push (@wholeBlue, $_);
						@blueLine = split(" ", $_);
						push (@openOnes, $_) if $blueLine[4] >= $numberDataSetsPerPeak;
						push (@closedOnes, $_) if $blueLine[4] == 0;
					}
				close BLUE;
				print STDERR "\trandomly selecting ~$numberOfPeaks open/closed sites...\n\n";
				$text_frameScreen -> update();
				
				@globalSelection = ();
				$range = @closedOnes;
				@globalSelection = (0) x $range;
				
				if ($range <= $numberOfPeaks)
					{
						@closedChromArray = @closedOnes;
					}
				
				if ($range > $numberOfPeaks)
					{
						my $generate = Math::Random::MT->new(); #windows only 
						my $randomNumberClosed;
						
						
						while ($closed < $numberOfPeaks) 
							{
								$randomNumberClosed = $generate->rand($range);
								$index = int($randomNumberClosed);

								next if $globalSelection[$index] > 0;
								$closedChrom{$index} = $closedOnes[$index];
								$closed += 1;
								$globalSelection[$index] = 1;
							}

						$x = 0;
						for $key ( sort {$a<=>$b} keys %closedChrom) 
							{
						           $closedChromArray[$x] = $closedChrom{$key};
						           $x += 1;
							}
					}
				my $peakTally;
				$peakTally = @closedChromArray;	
				$text_frameScreen -> update();
				
				@globalSelection = (0) x $range;
				$range = @openOnes;
				$globalSelection[$range] = 0;
				for (@globalSelection)
					{
						$globalSelection[$_] = 0;
					}

				if ($range <= $numberOfPeaks)
					{
						@openChromArray = @openOnes;
					}
				
				if ($range > $numberOfPeaks)
					{
						my $generate = Math::Random::MT->new();
						my $randomNumberOpen;

						while ($open < $numberOfPeaks) 
							{
								$randomNumberOpen = $generate->rand($range);
								$index = int($randomNumberOpen);

								next if $globalSelection[$index] > 0;
								$openChrom{$index} = $openOnes[$index];
								$open += 1;
								$globalSelection[$index] = 1;
							}

						$x = 0;
						for $key ( sort {$a<=>$b} keys %openChrom) 
							{
						           $openChromArray[$x] = $openChrom{$key};
						           $x += 1;
							}
					}
				
				$peakTally = @openChromArray;	
				$text_frameScreen -> update();
				
				$openRef = \@openChromArray;
				$closedRef = \@closedChromArray;

				# free some memory! 20130425
				%closedChrom = ();
				%openChrom = ();
				@wholeBlue = ();

				print STDERR "\tFor open signal:\n";
				$text_frameScreen ->update();
				
				@open = signalIntensity($openRef, 0, $samForAnalysis, $numberOfPeaks, $genomeSizeFile, $_[2], $_[3], $thresholdSignificanceLevel, $maxPeakPValue);
				$openReadsPerBin = $open[1];
				$openPeaksAssessed = $open[2];

				print STDERR "$openReadsPerBin reads per bin ($peakBinSize bp) at $openPeaksAssessed randomly selected sites common to $numberDataSetsPerPeak of 125 open chromatin data sets\n\n"; 
				print STDERR "\tFor closed signal:\n";
				$text_frameScreen ->update();
				@closed = signalIntensity($closedRef, 1, $samForAnalysis, $numberOfPeaks, $genomeSizeFile, $_[2], $_[3], $thresholdSignificanceLevel, $maxPeakPValue);
				
				$thresholdFromThreshold = $closed[0];
				$closedReadsPerBin = $closed[1];
				$closedPeaksCompleted = $closed[2];
				$pValueTableRef = $closed[3];

				print STDERR "\t$closedReadsPerBin reads per bin ($_[2] bp) at $closedPeaksCompleted randomly selected ENCODE closed chromatin sites.\n\n";
				print STDERR "\tcalculated read density threshold (p < $thresholdSignificanceLevel): $thresholdFromThreshold\n";
				print STDERR "\tusing flat threshold at $flatThreshold for peak calling.\n\n" if $flatThreshold ne 'NONE';
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
				
			}
		
		# need to put option here also for random data selection if no blueprint available.
		if ($closedAndOpen eq "NO")
			{
				### HERE
				print STDERR "\tLooking for chromosomes in $samForAnalysis... \n";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
				my $startTime = time;
				my %chromsPresent;
				my $headerOff = 0;
				open (my $targetChroms, "<", $samForAnalysis);
				while (<$targetChroms>)
					{
						if ($headerOff == 0)
							{
								my @header = split("", $_);
								$headerOff = 1 if $header[0] ne "@";
								next if $headerOff == 0;
							}
						$_ =~ /(chr\w*)/;
						$chromsPresent{$1} = 1 unless exists $chromsPresent{$1};
					}
				close $targetChroms;
				my $endTime = time;
				my $duration = $endTime - $startTime;
				### TO HERE




				print STDERR "\tReading chromosome sizes...\n\n";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;

				open (CHROMS, "<", "$genomeSizeFile") || die  "Unable to open $genomeSizeFile\n\n";;
				while (<CHROMS>)
					{	
						@chromLine = split(" ", $_);
						$end = $chromLine[1] + $total;
						$start =  1 + $total; 
						push (@chromName, $chromLine[0]) if $chromsPresent{$chromLine[0]} == 1; # HERE
						
						push (@chromStart, $start)if $chromsPresent{$chromLine[0]} == 1; # HERE
						push (@chromEnd, $end)if $chromsPresent{$chromLine[0]} == 1; # HERE
						$total = $total + $chromLine[1];
						$chromCount += 1;
						
					}
				die "\tnone of the chromosomes listed in $genomeSizeFile have been detected in $samForAnalysis.\n\n" unless scalar(@chromName) >= 1;
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
				close CHROMS;

				$range = $total - 1;
				my $randomPeakNumber = 0;
				
				print STDERR "\tSelecting $numberOfPeaks random sites to sample...\n\n";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;


				my $hashCount = 0;
				my $generate = Math::Random::MT->new();
				my $randomNumber;
				while ($hashCount < $numberOfPeaks)
				
					{
						$randomNumber = $generate->rand($range);
						$index = int($randomNumber) + 1;
						for ($x = 0; $x < $chromCount; $x += 1)
							{
								if (($index >= $chromStart[$x]) && ($index <= $chromEnd[$x]))
									{
										$randomPeakNumber+= 1;
										$randomPeakStart = $index - $chromStart[$x];
										$randomPeakEnd = $randomPeakStart + 10;
										$chrom = $chromName[$x];
										$readName = "#" ."$randomPeakNumber";
										$randomPeakString = "$chrom\t$randomPeakStart\t$randomPeakEnd\t$readName\n";
										$randomChromHash{$index} = $randomPeakString;

										$hashCount = keys %randomChromHash;
									}	
							} 	
					}	

				#need to sort the randomchromarray 
				$x = 0;
				for $key ( sort {$a<=>$b} keys %randomChromHash) 
					{
				           $randomChromArray[$x] = $randomChromHash{$key};
				           $x += 1;
					}

				$randomRef = \@randomChromArray;

				my @randomStringData = signalIntensity($randomRef, 1, $samForAnalysis, $numberOfPeaks, $genomeSizeFile, $_[2], $_[3], $thresholdSignificanceLevel, $maxPeakPValue);
				@random = split(" ", $randomStringData);

				$thresholdFromThreshold = $randomStringData[0];
				$randomReadsPerBin = $randomStringData[1];
				$randomPeaksCompleted = $randomStringData[2];
				$pValueTableRef = $randomStringData[3];

				print STDERR "\t$randomReadsPerBin reads per bin ($peakBinSize bp) at $randomPeaksCompleted random sites.\n";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
				print STDERR "\tcalculated read density threshold (p < $thresholdSignificanceLevel): $thresholdFromThreshold\n";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
				print STDERR "\tusing flat threshold at $flatThreshold for peak calling.\n\n" if $flatThreshold ne "NONE";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
			}
		return ($thresholdFromThreshold, $pValueTableRef);
	}




# # # # # # # # # # # # # # # # # 
# Sub to measure signal intensity  within each randomly selected target site
# # # # # # # # # # # # # # # # # 

sub bounce
	{
		$quit = 0;
	}
sub signalIntensity
	{

		print STDERR "\tassessing signal intensity...\n\n";
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
		my @tedPeaksArray = @{$_[0]};
		my @bedPeaksArray = @tedPeaksArray;

		my $kernalOn = $_[1];

		my $numberOfSubPeaks = $_[3];
		my $targetSamFile = $_[2];
		my $genomeSizeFile = $_[4];
		my $sizeOfBin = $_[5];
		my $sizeOfBackground = $_[6];
		my $thresholdSignificanceLevel = $_[7];
		my $maxPeakPValue = $_[8];
		my $distanceFromPeakCentre = $sizeOfBin/2;
		my $backgroundFromPeakCentre = $sizeOfBackground/2;
		my $reCalc = 1;
		my $currentTargetPeak = 0;		
		my $lowPeak = 0;	
		my $highPeak = 0;		
		my $peakCentre = 0;
		my $peakChrom = 0;
		my $peakName = 0;
		my $lowLimit = 0; 
		my $highLimit = 0;
		
		my $actualPeakCount = 0;
		my $currentValue = 0;
		
		my $headerLineCheckerOff = 0;
		my $s = 0;
		my $flyCount = 0;

		my @globalBin = ();
		my @splitArray = ();
		my @headerCheck = ();
				
		my @splitSamArray = ();
		my @lineChromSizes = ();
		my %chromOrderScore = ();
		my $simpleCount = 1;
		my @scoreArray = ();

		my @probabilityArray = ();
		my $backgroundScore = 0;
		my $backgroundLowLimit = 0;
		my $backgroundHighLimit = 0;
		my $correctedFlyCount = 0;
		my $meanBackground = 0;
		my $totalFlyCount = 0;

		my $returnString = 0;
		my $thresholdFromSignalIntensity = 0;
		my $peaksCompleted = 0;
		my $arrayChecker = 0;
		my $readsPerBin = 0;

		my @lowBack = ();
		my @highBack = ();
		my @lowBin = ();
		my @highBin = ();

		my @centrePoint = ();
		my $x = 0;
		my @lineSplitter = ();
		my @chromosomeNamesForIntensity = 0;

		#open target bed file, and randomly select $absoluteReadNumber reads, and put these into an array new file

		# get the order of chromosomes to exclude skips;
		open (CHROM, "<", "$genomeSizeFile") || die "$genomeSizeFile not found\n\n";
		while (<CHROM>)
			{
				@lineChromSizes = split(" ", $_);
				$chromOrderScore{"$lineChromSizes[0]"} = $simpleCount;
				$simpleCount += 1;
			}
		close CHROM;
		
		$actualPeakCount = @bedPeaksArray;
		
		print STDERR "\t$actualPeakCount sites were selected randomly.\n";
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
		for ($x = 0; $x<$actualPeakCount; $x += 1)
			{
				@lineSplitter = split (" ", $bedPeaksArray[$x]);
				$centrePoint[$x] = int(($lineSplitter[1] + $lineSplitter[2])/2);
				$chromosomeNamesForIntensity[$x] = $lineSplitter[0];
			}


# make the outer bins, and exclude any overlapping bins
my $lowBackCount = 0;
my $highBackCount = 0;
my $checkingCounters = 0;
my $nextEx = 0;
my $loopCount = 0;
my $diffCount = 0;
my $spliced = 0;
my $nextNextEx = 0;
my $totalRawCentralBinScore = 0;
my $totalCheckingCounters = 0;
while ($loopCount <= 10)
	{		
		$actualPeakCount = @centrePoint;
		
		for ($x = 0; $x<$actualPeakCount; $x += 1)
					{
						$lowBack[$x] = $centrePoint[$x] - $backgroundFromPeakCentre;
						$highBack[$x] = $centrePoint[$x] + $backgroundFromPeakCentre;
						#print STDOUT "$chromosomeNamesForIntensity[$x]: LOW: $lowBack[$x] - HIGH:  $highBack[$x]\n";
					}
		
		$lowBackCount = @lowBack;
		$highBackCount = @highBack;
		
		
		my $dontOverFlow = $actualPeakCount -1;
		
		for ($x = 0; $x<$dontOverFlow; $x += 1)
					{
						
						$nextEx = $x + 1;
						$nextNextEx = $nextEx + 1;
						#print STDOUT "$chromosomeNamesForIntensity[$nextEx]\t$nextEx: $lowBack[$nextEx]\n";
						if (($highBack[$x] > $lowBack[$nextEx]) && ($chromosomeNamesForIntensity[$x] eq $chromosomeNamesForIntensity[$nextEx])) 
							{
								$checkingCounters += 1;
								$spliced = splice (@centrePoint, $nextEx, 1);
								splice (@lowBack, $nextEx, 1);
								splice (@highBack, $nextEx, 1);
								splice (@chromosomeNamesForIntensity, $nextEx, 1);
							} 
						last unless defined($lowBack[$nextNextEx]);
					}
		

		$loopCount += 1;
		$totalCheckingCounters = $totalCheckingCounters + $checkingCounters;
		last if $checkingCounters == 0;
		$checkingCounters = 0;
	}

print STDERR "\t$totalCheckingCounters sites discarded for overlapping.\n\n";
$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
# make the boundary coordinates of inner bins
$actualPeakCount = @centrePoint;
for ($x = 0; $x<$actualPeakCount; $x += 1)
		{
			$lowBin[$x] = $centrePoint[$x] - $distanceFromPeakCentre;
			$highBin[$x] = $centrePoint[$x] + $distanceFromPeakCentre;
		}
		
# find out how many reads in each bin:
my $chr = 0;
my $lowBackground = 0;
my $lowCentre = 0;
my $highCentre = 0;
my $highBackground = 0;
my $targetLine = 0;
my @samArray = ();
my $backGroundClock = 0;
my $binClock = 0;
my @centreScoresArray = ();
my @backgroundScoresArray = ();
my $chrNameCheck = 0;
my $loopChromNameCheck = 0;

# From HERE:
# open (SAM, "<", $targetSamFile);
# while (<SAM>)
# 	{
# 		$targetLine = $_;
# 		@samArray = split(" ", $targetLine);
# 		@headerCheck = split("", $_);
# 		last if $headerCheck[0] ne "@";
# 		$headerLineCheckerOff = 1 if $headerCheck[0] ne "@";
# 	}

## check sites on each chromosome
my %chromSiteCount = ();
for ($x=0; $x<$actualPeakCount; $x+=1)
	{
		$chromSiteCount{"$chromosomeNamesForIntensity[$x]"} += 1;
	}

my $lastChrom = 0;
		$headerLineCheckerOff = 0;
		open (SAM, "<", $targetSamFile);
		while (<SAM>)
			{
				if ($headerLineCheckerOff == 0)
					{
						@headerCheck = split("", $_);
						$headerLineCheckerOff = 1 if $headerCheck[0] ne "@";
						$targetLine = $_ if $headerCheck[0] ne "@";
						next if $headerLineCheckerOff == 0;
						last if $headerLineCheckerOff == 1;
					}
			}		

		$targetLine =~ /\b(chr\w*)\b\t\b(\w*)\b/;
			my $lineChrom = $1;
			my $basePos = $2;

		for ($x=0; $x<=$#chromosomeNamesForIntensity; $x+=1)
			{
				if ($lastChrom ne $chromosomeNamesForIntensity[$x])
					{
						print STDERR "\tsampling signal at $chromSiteCount{$chromosomeNamesForIntensity[$x]} sites on $chromosomeNamesForIntensity[$x]...\n";
						$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;

						if ($chromosomeNamesForIntensity[$x] ne $lineChrom)
							{
								while ($chromosomeNamesForIntensity[$x] ne $lineChrom)
									{
										$targetLine = <SAM>;
										$targetLine =~ /\b(chr\w*)\b\t\b(\w*)\b/;
										$lineChrom = $1;
										$basePos = $2;
										last if $targetLine = eof;
									}
							}
						}
				
				while (($lineChrom eq $chromosomeNamesForIntensity[$x]) && ($basePos < $highBack[$x]))
					{
						$backGroundClock += 1 if (($basePos > $lowBack[$x]) && ($basePos < $highBack[$x]));
						$binClock += 1 if (($basePos > $lowBin[$x]) && ($basePos < $highBin[$x]));
						
						$targetLine = <SAM>;
						$targetLine =~ /\b(chr\w*)\b\t\b(\w*)\b/;
						$lineChrom = $1;
						$basePos = $2;
						last if $targetLine = eof;
					}

				push(@centreScoresArray, $binClock);
				push(@backgroundScoresArray, $backGroundClock);
				
				$binClock = 0;
				$backGroundClock = 0;
				$lastChrom = $chromosomeNamesForIntensity[$x];
			}
# TO HERE

my @standardArray = ();
my $correctedFlyCountPlus5000 = 0;

# take bin scores and make background corrected density scores
my $maximumBinScore = 0;
my $backgroundCorrectedDensity;

for ($x=0; $x<$actualPeakCount; $x+=1)
	{
		$meanBackground = ($backgroundScoresArray[$x]/$sizeOfBackground)*$sizeOfBin;
		$meanBackground = sprintf("%.0f", $meanBackground); #rounds the number of reads  per bin to integer;
		$meanBackground = int($meanBackground); #converts to int
		$backgroundCorrectedDensity = $centreScoresArray[$x] - $meanBackground;
		$densityFrequencyHash{$backgroundCorrectedDensity} += 1;
		$maximumBinScore = $backgroundCorrectedDensity if $backgroundCorrectedDensity > $maximumBinScore;

		$totalRawCentralBinScore = $totalRawCentralBinScore + $centreScoresArray[$x];
	}
# calculate some numbers		
$peaksCompleted = @centreScoresArray;

$readsPerBin = $totalRawCentralBinScore/$peaksCompleted;
$readsPerBin = sprintf("%.2f", $readsPerBin);

my $standardArrayCount = @standardArray;
$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;

		$thresholdFromSignalIntensity = kernel(\%densityFrequencyHash, $thresholdSignificanceLevel) if $kernalOn == 1;
		my %pValueTable = ();
		if (($kernalOn == 1) && ($maxPeakPValue eq "ON"))
			{
				print STDERR "\n\tcreating peak density p value table...\n";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
				for ($x=0; $x<=50000; $x+=1)
					{
						$pValueTable{$x} = peakPValue($x);
						$x=50001 if $pValueTable{$x} == "0.000000000001";
					}
			}

		@probabilityArray = ();
		@bedPeaksArray = ();
		my $pValueTableRef = \%pValueTable;
		print STDERR "\n\t$peaksCompleted sites sampled.\n\n";
		$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
		
		$returnString = "$thresholdFromSignalIntensity\t$readsPerBin\t$peaksCompleted\t\%pValueTable";

		return  ($thresholdFromSignalIntensity, $readsPerBin, $peaksCompleted, $pValueTableRef);

	}

# sub kernel runs only once: it takes an array of bin scores from the closed chromatin sites, and returns a threshold corresponding to the globally set $thresholdSignificanceLevel
sub kernel 
	{
		my %hashForKernel = %{$_[0]};
		my $thresholdSignificanceLevel = $_[1];
		my $n;

		foreach my $key ( keys %hashForKernel )
			{
				$n += $hashForKernel{$key};
			}

		my $bandWidth = 1;
		my $oneOverRootTwoPi = 0.39894228;
		my $e = 2.718281828;
		my $round = 0;
		my $probTotal = 0;
		my $eFactor = 0;
		my $eFigure = 0;
		my $gaussFigure = 0;
		my $rankNumber = 0;
		my $fracFactor = 0;
		my $interTotal = 0;
		my $actualTotal = 0;
		my @rankProbArray = ();
		my $posCount = 0;
		my $diff = 0;
		my $absDiff = 0;
		my $thresholdFromKernel = 0;

		for ($rankNumber = 0; $rankNumber <= 100; $rankNumber += 0.1)
			{
				
				foreach my $key ( keys %hashForKernel )
					{
					  for (my $x = 0; $x < $hashForKernel{$key}; $x += 1)
					  	{

					  		$diff = $rankNumber - $key;
							$absDiff = abs($diff);
							$eFactor = (($absDiff*$absDiff)/$bandWidth)/-2;
							$eFigure = $e**$eFactor;
							$gaussFigure = $oneOverRootTwoPi*$eFigure;
												
							$interTotal = $gaussFigure;
							$probTotal = $probTotal + $interTotal;
					  	}
					}

				$actualTotal = $probTotal/($n*$bandWidth);
				if ($actualTotal < $thresholdSignificanceLevel)
					{
						$thresholdFromKernel = sprintf("%.1f", $rankNumber);
						@rankProbArray = (); # frees memory;
						return $thresholdFromKernel;
						last;
					}

				push (@rankProbArray, $actualTotal);
				$probTotal = 0;
				$posCount = 0;
			}
	}

# calculates p values for individual peak maxima, using the global data array, @dataForPValue, which is filled by the signalIntensity sub.
sub peakPValue
	{
		my $maximaForP = $_[0];
		my $nP = 0;

		foreach my $key ( keys %densityFrequencyHash )
			{
				$nP += $densityFrequencyHash{$key};
			}

		die "array with sample bin scores is empty!\n\n" if ($nP == 0);
		
		my $bandWidth = 1;
		my $oneOverRootTwoPi = 0.39894228;
		my $e = 2.718281828;
		my $round = 0;
		my $probTotal = 0;
		my $eFactor = 0;
		my $eFigure = 0;
		my $gaussFigure = 0;
		my $fracFactor = 0;
		my $interTotal = 0;
		my $actualTotal = 0;
		my $diff = 0;
		my $absDiff = 0;
		
		foreach my $key ( keys %densityFrequencyHash )
			{
			  for (my $x = 0; $x < $densityFrequencyHash{$key}; $x += 1)
				  	{

						$diff = $maximaForP - $key;
						$absDiff = abs($diff);
						$eFactor = (($absDiff*$absDiff)/$bandWidth)/-2;
						$eFigure = $e**$eFactor;
						$gaussFigure = $oneOverRootTwoPi*$eFigure;
						$fracFactor = $absDiff/$bandWidth;
						$interTotal = $fracFactor*$gaussFigure;
											
						$probTotal = $probTotal + $interTotal;
					}
			}
		
		$actualTotal = $probTotal/($nP*$bandWidth);
		$actualTotal = sprintf("%.12f", $actualTotal);

		$actualTotal = "0.000000000001" if $actualTotal < 0.000000000001;
		return $actualTotal;
	}



# sub peakCaller takes two arguments: the name of the file to call peaks on, and the threshold density to call peaks at

sub peakCall
	{
		my $filename = $_[0];
		my $thresholdPeakCall = $_[1];
		my $centralBinSize = $_[2];
		my $binSize = $_[3];
		my $genomeSizeFile =  $_[4];
		my $stepSize =  $_[5];
		my %pValueTable = %{$_[6]};
		my $maxPeakPValue = $_[7];
		
		die "threshold calculation failed in peakCall sub.\n\n" if $thresholdPeakCall == 0;

		my %reads = ();
		my @line = ();
		my $token = 0;
		my $count = 0;
		my $binTotal = 0;
		my $backgroundTotal = 0;

		my @headerCheck = ();
		my $headerLineCheckerOff = 0;
		my @currentLineSplit = ();
		my $chromosome = 0;
		my $chromosomeSize = 0;
		my $currentBinStart = 0;
		my $currentBinEnd = 0;

		my $centralBinStart = 0;
		my $centralBinEnd = 0;
		my $centralBinScore = 0;
		my $binScore = 0;

		my $startString = 1;
		my @readStartPositionArray = ();
		my $arraySize = 0;

		my $peakOn = 0;
		my $backgroundScore = 0;
		my $segmentScore = 0;
		my $peakChr = 0;
		my $peakStart = 0;
		my $peakEnd = 0;
		my $peakLine = 0;
		my $peakMax = 0;
		my $peakNumber = 0;
		my @peakArray = ();
		my $peakChromSize = 0;

		my $i = 0;
		#find the highest value of key in pValueTableArray:
		my $maxPValueTableValue = 0;
		if ($maxPeakPValue eq "ON")
			{
				foreach my $tekkers (keys %pValueTable)
					{
						$maxPValueTableValue = $tekkers if $tekkers > $maxPValueTableValue;
					}
			}

		# create hash with chromkey and chromsize value
				my %hashChromSizes = ();
				open (CHROMSIZE, "<", "$genomeSizeFile") || die "$genomeSizeFile not found\n\n"; #$genomeSizeFile");
				while (<CHROMSIZE>)
					{
						chomp;
						my ($keyChromName, $valChromSize) = split /\t/;
						$hashChromSizes{$keyChromName} = $valChromSize; 
					}
				close CHROMSIZE;
				
				###start of density track making
				print STDERR "\n";
				open (ORIGINALSAM, "<", "$filename") || die "$filename not found\n\n";
				while (<ORIGINALSAM>)
					{
						if ($headerLineCheckerOff == 0)
							{
								@headerCheck = split("", $_);
								$headerLineCheckerOff = 1 if $headerCheck[0] ne "@";
								next if $headerLineCheckerOff == 0;
							}
						
						# from HERE
						next unless ($_ =~ /\b(chr\w*)\b\t\b(\w*)\b/);
						my $thisChrom = $1;
						my $thisPos = $2;
						next unless exists $hashChromSizes{$thisChrom};

						#@currentLineSplit = split(" ", $_);
													
						if ("$thisChrom" ne "$chromosome")
							{			
								$chromosome = "$thisChrom";
								#skip read it chromosome is not included in chromosome size file
								next unless exists $hashChromSizes{$chromosome};
								$chromosomeSize = $hashChromSizes{$chromosome};
								print STDERR "\tfinding peaks in $chromosome...\n";
								$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;

								$currentBinStart = $startString; #+ $offSetSubDR;
								$currentBinEnd = $currentBinStart + $binSize;
								$centralBinStart = ($currentBinEnd/2 - $centralBinSize/2) - 0.5; 
								$centralBinEnd = $centralBinStart + $centralBinSize;
								@readStartPositionArray = ();
								
							}
					
							push(@readStartPositionArray, $thisPos);
							while (("$thisPos" > "$currentBinEnd") && ($currentBinEnd < $chromosomeSize ))
								{	
									while ($readStartPositionArray[0]<$currentBinStart)
										{
											shift(@readStartPositionArray);
										} 
					
									$arraySize = @readStartPositionArray;
									for ($i = 0; $i < "$arraySize"; $i += 1)
										{
											if (($readStartPositionArray[$i] >= $currentBinStart) && ($readStartPositionArray[$i] < $currentBinEnd) && ($currentBinStart < $currentBinEnd))
												{
														$binScore += 1;
												}
										
											if (($readStartPositionArray[$i] >= $centralBinStart) && ($readStartPositionArray[$i] < $centralBinEnd) && ($centralBinStart < $centralBinEnd))
												{
														$centralBinScore += 1;
												}

										}
											
									$backgroundScore = ($binScore/$binSize)*$centralBinSize; #can int or round this<---
									$backgroundScore = sprintf("%.0f", $backgroundScore);
									$backgroundScore = int($backgroundScore);
									$segmentScore = $centralBinScore - $backgroundScore;
									
									if (($segmentScore >= $thresholdPeakCall) && ($peakOn ==0))
										{
											$peakOn = 1;
											$peakStart = $centralBinStart;
											$peakMax = $segmentScore;
											$peakEnd = $centralBinEnd;
											$peakChr = $chromosome;
											$peakChromSize = $chromosomeSize; # HERE
										}		

									if (($segmentScore >= $thresholdPeakCall) && ($peakOn ==1))
										{
											$peakMax = $segmentScore if $segmentScore > $peakMax;
											$peakEnd = $centralBinEnd;
										}

									if (($segmentScore < $thresholdPeakCall) && ($peakOn == 1))
										{
											$peakNumber += 1;
											if ($maxPeakPValue eq "ON")
												{
													$peakMax = "$pValueTable{$peakMax}" if exists $pValueTable{$peakMax};
													$peakMax = "0.000000000001" if $peakMax > $maxPValueTableValue;
												}

											$peakEnd = $peakChromSize if $peakChr ne $chromosome; # HERE
											$peakLine = "$peakChr\t$peakStart\t$peakEnd\tpk$peakNumber\t$peakMax\t+\n";
											print $resultsOut "$peakLine";
											
											$peakOn = 0;
										}

									
									if (($segmentScore < $thresholdPeakCall) && ($peakOn == 0))
										{

										}

									$currentBinStart += "$stepSize";
									$currentBinEnd += "$stepSize";
									$centralBinStart += "$stepSize";
									$centralBinEnd += "$stepSize";
									$binScore = 0;
									$centralBinScore = 0;

								}
					}
				close ORIGINALSAM;
				close $resultsOut;
				print STDERR "\n\t$peakNumber peaks found in $filename.\n\n";
				$text_frameScreen ->update(); die "Program disrupted by user.\n\n" if $quit == 1;
				return $peakNumber;
				
	}

sub fileTest
	{
		my $format = $_[0];
		my $file = $_[1];
		
		my $headerOff = 0;
		my @line;
		my @sameLine;
		my $samFORMAT;
		my $samDisorder;
		my $samOrder = 0;
		my $header;
		my $samCount = 0;
		my $chrOrder;
		my $chrDisorder;
		my %samTags = ('@CO' => 1, '@RG' => 1, '@SQ' => 1, '@HD' => 1, '@PG' => 1);

		### defining SAM format
		if ($format eq 'SAM')
			{
				$header = 'NONE';
				$samFORMAT = 'OK';
				$samDisorder = 'OK';
				$chrDisorder = 'OK';
				
				if (-z $file)
					{
						$samFORMAT = 'BAD';
						$samDisorder = 'BAD';
						$header = 'NONE';
						$chrDisorder = 'BAD';
					}
				
				open (my $samFile, "<", $file) or die "Unable to open $file.\n\n";
				while (<$samFile>)

					{
						next unless $_ =~ /\w/;
						if (eof)
							{
								$samFORMAT = 'BAD';
								$samDisorder = 'BAD';
								$header = 'NONE';
								$chrDisorder = 'BAD'
							}

						
						if ($headerOff == 0)
							{
								@line = split(" ", $_);
								$header = 'OK' if defined $samTags{$line[0]};
								$headerOff = 1 unless exists $samTags{$line[0]};
							}
						if ($headerOff == 1)
							{
								
								@sameLine = split(" ", $_);

								$samFORMAT = 'BAD' unless defined $sameLine[7];
								if (defined $sameLine[7])
									{
										if (
											($sameLine[0] =~ /[^!-?A-~]/) ||
											($sameLine[1] =~ /\D/) ||
											(($sameLine[2] !~ /chr/) && ($sameLine[2] ne '*')) ||
											($sameLine[3] =~ /\D/) ||
											($sameLine[4] =~ /\W/) ||
											(($sameLine[5] =~ /\W/)  && ($sameLine[2] ne '*')) ||
											($sameLine[6] =~ /[^!-?A-~]/) ||
											($sameLine[7] =~ /[^!-?A-~]/) ||
											($#sameLine < 8)
										)
											{
												$samFORMAT = 'BAD';
											}
									} 
									
								$samDisorder = 'BAD' unless defined $sameLine[3];
								$chrDisorder = 'BAD' unless defined $sameLine[2];

								$samDisorder = 'BAD' unless looks_like_number($sameLine[3]);


								if ($samDisorder eq 'OK')
									{
										if ((looks_like_number($sameLine[3])) && ($samCount >= 1))
											{
												
												if ($sameLine[3] < $samOrder)
													{
														$samDisorder = 'BAD' unless ($sameLine[2] ne $chrOrder);
													}
											}
									}
								
								if ($chrDisorder eq 'OK')
									{
										if ((defined $sameLine[2]) && (defined $chrOrder) && ($samCount >= 1))
											{
												unless ($sameLine[2] eq $chrOrder)
													{
														$chrDisorder = 'BAD';
													}
											}
										
									}
								

								$samOrder = $sameLine[3] if defined $sameLine[3];
								$chrOrder = $sameLine[2] if defined $sameLine[2];
								$samCount += 1;
								last if $samCount == 20; 
							}
					}

				return ($samFORMAT, $samDisorder, $header, $chrDisorder);

			}

		if ($format eq 'BED')
			{
				
				my $bedFORMAT = 'OK';
				my $bedCount = 0;
				
				if (-z $file)
					{
						$bedFORMAT = 'BAD';
					}
				open (my $bedFile, "<", $file) or die "Unable to open $file\n\n";

				while (<$bedFile>)
					{
						@line = split (" ", $_);
						
						if (eof)
							{
								$bedFORMAT = 'BAD';
							}


						if (
								($line[0] !~ /chr/) ||
								($line[1] =~ /\D/) ||
								($line[2] =~ /\D/) 
							)
								{
									$bedFORMAT = 'BAD';
								}

						$bedCount += 1;
						last if $bedCount == 2;
					}

				return ($bedFORMAT);

			}

		if ($format eq 'CHROM')
			{
				
				my $chromFORMAT = 'OK';
				my $chromCount = 0;
				
				if (-z $file)
					{
						$chromFORMAT = 'BAD';
					}
				open (my $chromFile, "<", $file) or die "Unable to open $file\n\n";

				while (<$chromFile>)
					{
						@line = split (" ", $_);
						
						# if (eof)
						# 	{
						# 		$chromFORMAT = 'BAD';
						# 	}


						if (
								($line[0] =~ /[^!-?A-~]/) ||
								($line[1] =~ /\D/) ||
								($#line != 1)

							)
								{
									$chromFORMAT = 'BAD';
								}

						$chromCount += 1;
						last if $chromCount == 1;
					}

				return ($chromFORMAT);

			}
	}

sub helpUsage
	{

my $string = 
'=head1 NAME

	PeaKDEck_Win v1.1 - a perl/Tk kernel density estimator based peak caller for I<DNaseI-seq> data. 

=head1 SYNOPSIS

	Numerical sorting: sorts sam format file by read position.
	Sam filter: groups sam reads by chromosome, filters data for mapq & uq scores, 
				and optionally removes PCR read duplication. 
	Random read selection: random selection of n reads from sam file.
	Density analysis: generates continuous density track from mapped, ordered sam file.
	Peak calling: identifies read density peaks in mapped, ordered sam file.
	Size ordering of peaks: orders bed files by peak size score.

=head1 ARGUMENTS

=head2 Numerical sorting 
	
	Sorts sam format reads by base start position, irrespective of chromosome. Equivalent
	to the linux/unix/osx command: [sort -n --key=4,5 filename.sam > sortedFilename.sam].
	For fast results, memory corresponding to ~2.5 times file size should be available.

=head2 Sam filtering
	
	Sorts sam files by chromosome, in the order that chromosomes appear in the chromosome
	size file. The chromosome size file is mandatory. The chromsome size file is a plain 
	text, tab separated file in the format: 

		chr1	249250621
		chr2	243199373
		chr3	198022430
		.................
		chrN 	size(bp)

=head3 Mandatory settings

	chromosome size file [/path/to/chromosomeSizeFile.txt]
		Specifies the path to the text file containing tab separated list of chromosome names
		and sizes.

=head3 Optional settings

	MapQ Limit [integerValue]
		Specifies a mapq cutoff score for filtering. Reads with a mapq score less than the 
		supplied value will be removed from the resulting filtered file. By default, -q is 
		set to zero, so no filtering for mapq scores will occur.

	UQ limit [integerValue]
		Specifies a UQ base mismatch score for filterering. Reads with mismatch scores greater
		than this value will be removed from the filtered dataset. By default, -u is set to 
		10000, so that no filtering by uq score will occur.

	Sam header (opt) [samHeaderFile.sam]
		Specifies a file containing a sam header, which if set, will be included at the beginning
		of the newly filtered file.

	PCR delete [ON|OFF]
		Allows PCR duplicate reads to be removed from sam file. Reads are considered PCR duplicates
		if adjacent reads have identical chromosome, start position, mapq score, and sequence. By 
		default -PCR is set to OFF, so no filtering of PCR duplicates will occur. To detect PCR
		duplicates, chromosomes must be in numerical order (see Numerical sorting above).

=head2 Random read selection 
	
	Randomly selects a target number of reads from a specified sam file. Selected reads are
	printed to the chosen output file by default.

=head3 Mandatory settings

	Number [integer]
		Specifies the target number of reads to be randomly selected from the given sam file.
		The number of reads must by a positive whole number.

=head2 Density analyzer 

	Creates a smoothed, unitless read density track in wig format, representing the distribution 
	of reads in the given sam file. Sam files must be grouped by chromosome, and ordered by read 
	start position (see Numerical sorting and Sam filtering above). The order of chromosomes in 
	the density track is determined by the order in which they appear in the mandatory 
	chromosome size file (see Sam filtering for chromosome size file format). By default, the 
	results are printed to the chosen output file.


=head3 Mandatory settings

	chromosome size file [/path/to/chromosomeSizeFile.txt]
		Specifies the path to the text file containing tab separated list of chromosome names
		and sizes.

=head3 Optional settings

	1/2 bin size [positiveInteger]
		Specifies the one-tailed size of the smoothing bin. By default, -t is set to 150, giving a bin
		size of 300 bp. This value determines both the size of sampling bin, and the width of the 
		Gaussian probability density function used to calculate read densities, and must by a 
		postitive whole number.

	Step size [positiveInteger]
		Specifies the size of steps by which the probability density function and sampling bin move 
		along the genome. By default, -STEP is set to 100. Smaller step sizes proportionately
		increase the number of calculations carried out, and therefore the time taken for the 
		analysis. -STEP must be a positive whole number.

	Sigma [positiveInteger]
		Specifies the standard deviation of the probability density function. This value determines how 
		broadly the read density scores are spread over each sampling bin, and therefore determines
		the degree of smoothing that occurs. By default -d is set to 50, and must be a positive whole
		number.

	Min thresh [positiveInteger]
		Specifies a low threshold, below which read density scores won\'t be included in probability
		density function calculations. By default, -t is set to the number of reads expected to occur
		in the set bin size if the number of reads in the dataset were randomly distributed. All reads
		present in the data set will be included in the analysis if -t is set to 0. -t must be a non-
		negative whole number.

	Max thresh [positiveInteger]
		Specifies a high threshold, above which read density scores won\'t be included in probability
		density function calculations. By default, -m is set to 100000000, ensuring that no reads
		will be excluded from analysis in default settings.

	Offset [integer]
		Specifies a track offset. All positions in the resulting wig file will be offset by this value.
		For DNaseI-seq data, the read start sites are considered DNaseI cutting sites, and so by 
		default, -o is set to 0. If the centre of the DNA fragment is considered the point of interest
		(for example, in ChIP-seq), setting -o to half the average fragment size may give a more
		precise depiction of signal localisation.

=head2 Peak calling 

	Identifies peaks in the provided sam file, and provides output in bed format to the chosen output 
	file. Sam 
	files must be grouped by chromosomes, and ordered by read position (see Numerical sorting 
	and Sam filtering above). The order of chromosomes in the peak file is determined by 
	the order in which they appear in the mandatory chromosome size file (see Sam filtering for 
	chromosome size file format).

=head3 Mandatory settings

	chromosome size file [/path/to/chromosomeSizeFile.txt]
		Specifies the path to the text file containing tab separated list of chromosome names
		and sizes.

=head3 Optional settings

	Bin size [positiveInteger]
		Specifies the size of the central sampling bin. By default, -bin is set to 300, which 
		represents the expected average feature size. -bin must by set to a positive whole number

	Back size [positiveInteger]
		Specifies the size of the background sampling bin. By default, -back is set to 3000, ten
		times the size of the central sampling bin. -back must be set to a positive whole number
		and must be larger than the size of the central bin.

	Step size [positiveInteger]
		Specifies the size of steps by which the sampling bin moves along the genome. By default, 
		-STEP is set to 100. Smaller step sizes proportionately increase the number of calculations 
		carried out, and therefore the time taken for the analysis. -STEP must be a positive whole 
		number.

	Flat thresh [positiveInteger]
		Specifies a flat threshold for peak calling in reads per bin. When -FLAT is set, the
		threshold calculated by PeaKDEck for peak calling is overridden, and the value given 
		by -FLAT is used in its place. FLAT must by a positive number.

	Blueprint file (opt) [/path/to/blueprintFile.bed]
		This option provides the path to a bed file which contains a list of contiguous genomic
		loci indicating the sites of known open chromatin sites, tagged with the number of cell
		types with open chromatin at that site. The format is as follows:

			chr1	1	10099	C#1	0
			chr1	10100	10330	#1	37
			chr1	10331	10344	C#2	0
			chr1	10345	10590	#2	4
			chr1	10591	16099	C#3	0

		where the columns respectively indicate the chromosome name, stie start position, site
		end position, element name, and number of cell types with open chromatin at that site.
		When this file is provided, PeaKDEck calculates signal-to-noise ratio, and calculates 
		the background probability distribution from sites selected from loci with no known 
		open chromatin.

	npBack [positiveInteger]
		Sets the number of sites to randomly select to calculate the background probability 
		distribution. By default this is set to 50000 sites. -npBack must be a positive whole
		number.

	p-value [probabilityValue]
		Specifies the positive limit of the probability distrubtion for selecting the corrected
		read density for peak threshold. By default, -sig is set to 0.001. -sig must be a 
		positive number between 0 and 1.

	PVAL score [ON|OFF]
		Peaks are scored with the maximum corrected read density recorded during that peak by 
		default. setting -PVAL to ON converts this corrected read density to a probability value
		from the background probability distribution used to calculate the threshold. This
		value represents the probability that a corrected read density of that magnitude 
		belongs to the background probability distribution.

=head2 Top peak selection 
	
	Sorts peak bed files in descending order by corrected read density score. By default,
	the sorted peaks are printed in bed format to the chosen output file. The target file must 
	by in bed format.

=head3 Mandatory settings

=head3 Optional settings
	
	Number [positiveInteger]
		This specifies the number of peaks to include in the resulting bed file, from the
		highest scoring peak downwards. By default, -n is set to ALL, and all the peaks 
		are printed to the output file. -n must be either \'ALL\' or a positive whole number. 

=head1 DESCRIPTION

	PeaKDEck is a utility written in perl, mainly intended for use in the identification
	of peaks in mapped DNaseI-seq data. It also includes a set of utilities for 
	processing and manipulation of this data from the mapping stage forwards. It works
	on data in sam format.

	PeaKDEck selects a threshold read density for peak calling by constructing a 
	probability distribution of background read density scores using kernal density
	estimation. It selects a threshold by selecting a read density that is \'significantly\' 
	outside this background probability distribution. All measurements of read density are 
	corrected for local background variation in signal intensity.

	PeaKDEck is available at www.ccmp.ox.ac.uk/PeaKDEck.

=head1 FAQs

=head2 What are the system requirements?

	The command line and GUI PeaKDEck applications have been tested on OSX (Mountain Lion),
	Ubuntu 12.04 LTS, Windows XP and Windows 7. The system requirements are largely dependent on 
	the size of data files being used. We recommend at least 4GB memory for basic use with 
	small data files. For the numerical sorting of sam files, ~(file size * 2.5) free memory 
	is required for efficient sorting. For the command line applications, we recommend Perl 
	v5.12 or later. On Windows, PeaKDEck was tested with Strawberry Perl. 

=head2 How do I install PeaKDEck?

	PeaKDEck GUI: On Windows, PeaKDEck should run without the need to install Perl, or
	orther additional softwares. On Linux and OSX platforms, the X Window System (X11 or 
	XQuartz) must be installed.

	PeaKDEck command line: to use the PeaKDEck command line application, Perl must be 
	installed on your computer. We recommend Perl v5.12 or later. On Linux and OSX platforms,
	no other software is required to run the command line application. On the Windows 
	platform, a pseudorandom number generating module (Math::Random::MT) is required, and 
	is available through CPAN for Strawbery Perl users, and PPM (Math-Random-MT) for  
	ActiveState users. 

=head2 Which short read file formats does PeaKDEck work with?

	At present, PeaKDEck only works with files in the SAM format (see 
	samtools.sourceforge.net/SAMv1.pdf for details). 

=head2 Which application should PeaKDEck be opened with?

	On the OSX platform, after launching the PeaKDEck GUI application (having installed 
	XQuartz), you may be prompted to choose an application with which to open PeaKDEck.
	PeaKDEck should be opened with the Terminal application (located at 
	/Applications/Utilities/Terminal.app).

=head2 Why is the GUI freezing?

	As yet, the PeaKDEck GUI is not a multi-threaded program. As such during data processing, 
	the GUI may appear frozen or unresponsive. Particularly on the Windows platform. For now,
	this is expected behaviour. The GUI will refresh when new status updates are available,
	and will return to full responsiveness when data processing has finished.

=head1 EXAMPLES

	see SYNOPSIS above.

=head1 CAVEATS

=head1 AUTHOR
	
	michael mccarthy
	michaeltmccarthy@gmail.com

=head1 ACKNOWLEDGEMENTS

=head1 SEE ALSO

=cut';
return $string;
}



