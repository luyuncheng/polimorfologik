#Makefile do tworzenia s�ownika morfologicznego
#pliki:
#afiksy - plik ze specyfikacj�, kt�ra flaga ispella odpowiada za okre�lony wyraz
#formy.txt - plik s�ownika: wyraz - flagi i ko�c�wki ispella
#odm.txt - aktualny s�ownik z witryny www.kurnik.pl/slownik (s�ownik odmian)
#pl_PL.aff - aktualny plik ze s�ownika myspell z witryny kurnik.pl
#pojedyncze.txt - wyrazy nieodmienne
#nieregularne.txt - odmiany nieregularne
#slownik_regularny - s�ownik morfologiczny odmian regularnych, generowany
#morfo_baza.txt - baza morfologiczna (odwzorowanie flagi i ko�c�wki ispella -> oznaczenia morfosyntaktyczne)
#baza_nieodmiennych.txt - wyrazy z r�cznie dobranymi anotacjami
#polish.all - ze s�ownika alternatywnego
#build - ze s�ownika alternatywnego

formy formy.txt formy_pdst.txt: polish.all
	gawk -f aff5.awk polish.all >formy.txt
	gawk -f forma_pdst.awk polish.all >formy_pdst.txt 
lacz formy_ost.txt: formy.txt formy_pdst.txt
	cat formy.txt formy_pdst.txt | sort -u > formy_ost.txt
slownik:
#slownik regularny
	gawk -f morpher.awk formy_ost.txt >slownik_regularny.txt
#przygotowanie form nieregularnych 
	gawk -f nietypowe.awk polish.all >bez_flag.txt
	gawk -f dopisane.awk odm.txt >nieregularne.txt
anot:
	gawk -f anot_niereg.awk nieregularne.txt > slownik_niereg.txt
#po��czenie
	cat slownik*.txt | sort -u > morfologik.txt

fsa:
	gawk -f morph_data.awk morfologik.txt | fsa_ubuild -O -o polish.dict
	
all: formy lacz slownik anot fsa

test:
#formy_ht_3.txt - plik testowy
#	gawk -f compare.awk formy_ht_3.txt >konflikty.txt
	grep "##" slownik_regularny.txt >raport.txt
#	gawk -f test_oboczne.awk slownik_regularny.txt >>raport.txt

clean:
	rm formy*.txt
	rm bez_flag.txt
	rm slownik*.txt
	rm nieregularne.txt
	rm afiksy.txt