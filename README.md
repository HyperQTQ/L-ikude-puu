# Tallinna Reaalkooli poolametlik LaTeX alusfail

Originaalne autor Sandra Schumann (128c), uuendatud: Kaarel Kivisalu (135a), Peeter Aleksander Randla (137a)

Kasutamiseks on soovituslik Overleaf. Seal tuleb ainult settingutes pdfLaTeX'i asemel LuaLaTeX valida, ja TeX Live versioon võiks olla vähemalt 2020.

Kui tahta oma arvutis kompileerida, siis tuleb ise installida TeX Live või MiKTeX. Kompileerida saab käsuga `latexmk -lualatex 135d_EesnimiPerekonnanimi.tex`.

Asjad, mida UT'd kirjutades tähele panna:

* Viited tabelitele ja joonistele tuleb panna sulgudesse, alusfail seda automaatselt ei tee. Nt `(Tabel \ref{x})` ja `(Joonis \ref{x})`
* Tabelites on soovituslik kasutada ainult 3 rõhtjoont (ja mitte ühtegi püstjoont): päise kohal, päise all ning tabeli lõpus. Päis on soovituslik boldis panna.
* Kasuta alati `\begin{equation*}` ja `\end{equation*}`, mitte `$$`, muidu ei joondata neid õigesti.
* Juhendi järgi peavad kõik joonised olema "normaalsuurusega, mitte poole lehekülje suurused", seega tõenäoliselt tuleb käsitsi `\includegraphics`'i width'i muuta.
* Diagrammide tekst on soovitatavalt sama tähesuurusega nagu ülejäänud tekst... yeah, good luck with that.
