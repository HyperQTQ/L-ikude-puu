%%% Originally written by Sandra Schumann in 2012
%%% Modified by Kaarel Kivisalu in 2018
%%% kaarel.kivisalu@real.edu.ee (kaarel.kivisalu@gmail.com pärast 06.2020)
%%% Modified by Peeter Aleksander Randla in 2020

%------------------------------------------------------------------------
%   CLASS DEFINITION AND PARAMETERS
%------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trkut}[2018-12-02 TRK UT class]

\LoadClass[oneside, 12pt, headings=small, numbers=endperiod]{scrreprt}% Numbrite vahel ja lõpus on punkt, chapter font large, 12pt.

\RequirePackage{etoolbox}% Scriptimismacrod
\RequirePackage{polyglossia}% Eesti keele tugi
\setdefaultlanguage{estonian}
\RequirePackage{csquotes}% Eesti jutumärgid käsuga \enquote{}
\RequirePackage{graphicx}% Joonised
\RequirePackage[colorlinks,citecolor=black,filecolor=black,linkcolor=black,urlcolor=black,bookmarksnumbered]{hyperref}% Sisukorras ja viidetel on lingid
\RequirePackage[fleqn]{amsmath} % Joondame valemid vasakule 
\RequirePackage{siunitx}
\RequirePackage[title,titletoc]{appendix}
\RequirePackage{fontspec}

%---------------------------------------------
%   ÄÄRISED
%---------------------------------------------

\RequirePackage[layout=a4paper, top=2.5cm, bottom=2.5cm, left=3cm, right=2cm, includeall=false]{geometry}
\geometry{%
    layout=a4paper,
    top=2.5cm,
    bottom=2.5cm,
    left=3cm,
    right=2cm,
    includeall=false
}

%----------------------------------------------------------------------------------------
%   PENALTIES
%----------------------------------------------------------------------------------------

\doublehyphendemerits=10000%    No consecutive line hyphens
\brokenpenalty=10000%           No broken words across columns/pages
\widowpenalty=9999%             Almost no widows at bottom of page
\clubpenalty=9999%              Almost no orphans at top of page
\interfootnotelinepenalty=9999% Almost never break footnotes

%---------------------------------------------
%   NUMMERDAMINE
%---------------------------------------------

%% Leheküljenumbrid algavad sissejuhatuse teiselt leheküljelt
\renewcommand\thepage{}

% after the first \chapter (which should be \addchap{Sissejuhatus}):
\AddtoOneTimeDoHook{heading/branch/nostar/chapter}{%
    % re-enable page numbering,
    \renewcommand{\thepage}{\arabic{page}}%
    % but don't show the page number for the current (first) page
    \thispagestyle{empty}%
}

%---------------------------------------------
%   SISUKORD
%---------------------------------------------

\KOMAoptions{toc=chapterentrydotfill}%      Peatükkide taga on punktiirjoon
\addtokomafont{chapterentry}{\mdseries}%    Peatükid ei ole boldis
%\renewcommand*{\@pnumwidth}{1em}%          Punktiirjoone ja leheküljenumbrite vahe
\setcounter{tocdepth}{99}%                  Näitame kõikide - ka väga madala taseme - jaotuste pealkirju
\setcounter{secnumdepth}{99}%               Numbreid ka neile

% A somewhat interesting hack to make table of contents squeeze together to fit
% onto one page if possible.
% The way baselineskip usually works is that \baselineskip is set by the font,
% and doesn't have any shrink/stretch. Then \baselinestretch is set by the user,
% and \baselinestretch\baselineskip (i.e. the product of them) is used as the
% actual baseline skip. But we want the final value to have some shrink. Since
% baselinestretch itself is just a number, not a dimension, it can't have a
% shrink/stretch component. So we need to give the stretch/shrink to
% baselineskip. Luckily, it seems that TeX doesn't really mind us redefining
% baselineskip in terms of itself, so we can pretty much reimplement
% baselinestretch manually (and add the desired shrink component). The downside
% is that it has to be redone every single time baselineskip changes, which
% happens each time the font changes. Though it seems that tocline has enough
% nested groups so that redefining it at the beginning of each toc entry works
% well enough.

% First, set baselinestretch to 1.0 at the start of TOC
\BeforeStartingTOC{\renewcommand{\baselinestretch}{1.0}}
% Then before each TOC entry, set baselineskip itself to 1.5x, with possibility
% to shrink down to 1.2x
% (note that this command still needs to be called before each TOC entry, this
% is done with the RedeclareSectionCommands later)
\newcommand{\settocblskip}{
    \setlength{\baselineskip}{1.5\baselineskip minus 0.3\baselineskip}
}

%---------------------------------------------
%   TABELID, JOONISED, VÕRRANDID
%---------------------------------------------

\RequirePackage{enumitem}
\setlist{nosep, before={\parskip=0pt}}

% Left-align all captions. Always.
\RequirePackage{caption}
\captionsetup{justification=justified,singlelinecheck=false}

% Joonis vahetult seda kirjeldava teksti juures ehk sama alapeatüki sees
\RequirePackage[section]{placeins}

% Captions to "Caption" style instead of "Source".
\newcommand{\trkcaptionsetup}{\captionsetup{labelformat=simple, labelsep=period, labelfont=normalfont, font=normalfont}}
\trkcaptionsetup % And this is also the default
% Captions to "Source" mode. Only used internally by \allikas
\newcommand{\captionstosource}{\captionsetup{labelformat=simple, labelsep=period, font=normalfont}}
% Add source to a figure or table.
\newcommand{\allikas}[1]{\vspace{-1em}\captionstosource\caption*{Allikas: #1}\trkcaptionsetup}

% Töö kõik tabelid tuleb nummerdada läbiva numeratsiooniga (ja kui juba tabelid, siis muu ka vist)
\RequirePackage{chngcntr}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{equation}{chapter}
\counterwithout{footnote}{chapter}

%---------------------------------------------
%   PAIGUTUS JA FORMAAT
%---------------------------------------------

\RequirePackage{microtype}% Teeb paigutuse paremaks

% jutumärgid on automaatselt "ilusad"
\MakeOuterQuote{"}

% These 2 commands are inserted into the TOC to not add dots after appendix
% names - i.e. "Lisa 1 Pealkiri" instead of "Lisa 1. Pealkiri". They redefine a
% KOMA-script internal macro \autodot which usually either prints a dot or not,
% depending on package options. But since we load the package in this file, we
% can ignore all that behavior and make it print the dot always.
\NewDocumentCommand{\appendixtocentry}{}{\renewcommand{\autodot}{}}
\NewDocumentCommand{\appendixtocentryend}{}{\renewcommand{\autodot}{.}}
% This overwrites a hyperref internal macro which prints the section number in
% the PDF table of contents. We make it insert a dot when necessary
\newcommand{\pdftocdot}{.}
\renewcommand{\Hy@numberline}[1]{#1\pdftocdot{} }

% we can't use AddToHook{env/appendices/begin} because that executes before
% \appendices itself, and we need to redefine some macros after it.
\apptocmd{\appendices}{%
    % the appendix package uses alphabetic numbering by default,
    % we need arabic numbering
    \renewcommand\thechapter{\arabic{chapter}}%
    % appendix doesn't seem to cooperate with KOMA-script well, so manually
    % fix the chapter prefix
    \renewcommand{\chapterformat}{\chapapp\nobreakspace\thechapter\enskip}%
    \renewcommand{\chaptermarkformat}{\chapapp\nobreakspace\thechapter\enskip}%

    \addtocontents{toc}{\appendixtocentry}%
    \renewcommand{\pdftocdot}{}%
}


\AddToHook{env/appendices/end}{%
    \addtocontents{toc}{\appendixtocentryend}%
}

% Font size
% \tiny         6pt
% \scriptsize   8pt
% \footnotesize 10pt
% \small        10.95pt
% \normalsize   12pt
% \large        14.4pt (overriden to 14pt)
% \Large        17.28pt (overriden to 16pt)
% \LARGE        20.74pt
% \huge         24.88pt
% \Huge         24.88pt

% manually fix font sizes that are used by headings
% these baselineskips (2nd number) are 1.2x font size
\renewcommand\large{\@setfontsize\large{14pt}{16.8pt}}
\renewcommand\Large{\@setfontsize\Large{16pt}{19.2pt}}

\renewcommand{\baselinestretch}{1.5}%   Reavahe on 1,5
\setlength{\parindent}{0pt}%            Taandridasid pole
\setlength{\parskip}{12pt}%             Lõiguvahe on 12 pt
\setlength{\topskip}{0pt}%              Ülaääre ja teksti vahel pole vaba ruumi
\setlength{\mathindent}{0pt}%           Valemid olgu vasaku ääre vastas

% Pealkirjade vahed
\RedeclareSectionCommand[
    beforeskip=2.5cm,
    tocbeforeskip=0pt,
    tocentryformat={\settocblskip}]{chapter}
\renewcommand*{\chapterheadendvskip}{\vspace{0em}}
\RedeclareSectionCommands[
    beforeskip=1pt,
    afterskip=0pt,
    runin=off,
    tocentryformat={\settocblskip},
    indent=0pt
]{section,subsection,subsubsection,paragraph,subparagraph}
\RedeclareSectionCommand[tocindent=2em]{section}
\RedeclareSectionCommand[tocindent=4em]{subsection}
\RedeclareSectionCommand[tocindent=6em]{subsubsection}
\RedeclareSectionCommand[tocindent=8em]{paragraph}
\RedeclareSectionCommand[tocindent=10em]{subparagraph}

% Pealkirjad boldis ja tekstiga sama fondiga
\setkomafont{disposition}{\rmfamily\bfseries}

% lingid sama fondiga, mis tekst
\urlstyle{same}

%---------------------------------------------
%   TIITELLEHT
%---------------------------------------------
\newcounter{numjuhendajad}

\RequirePackage{xparse}
\NewDocumentCommand{\autor}{m}{\newcommand{\@autor}{#1}\renewcommand{\@author}{#1}}
\NewDocumentCommand{\pealkiri}{m}{\newcommand{\printpealkiri}{#1}\renewcommand{\@title}{#1}}
\NewDocumentCommand{\juhendaja}{m}{\listadd{\juhendajalist}{#1}\stepcounter{numjuhendajad}}
\NewDocumentCommand{\klass}{m}{\newcommand{\@klass}{#1}}
\NewDocumentCommand{\koht}{m}{\newcommand{\@koht}{#1}}
\NewDocumentCommand{\asutus}{m}{\newcommand{\@asutus}{#1}}
\NewDocumentCommand{\paber}{m}{\newcommand{\@paber}{#1}}

% Vaikeväärtused
\paber{Uurimistöö}
\asutus{Tallinna Reaalkool}
\koht{Tallinn}

% Tiitellehe genereerimine
\renewcommand{\maketitle}{%
    \newpage
    \thispagestyle{empty}
    \large
    \begin{center}
        \@asutus
    \end{center}
    \vspace{8cm}
    \begin{center}
        {\LARGE\textbf{\@title}}

        \@paber
    \end{center}
    \vspace{2cm}
    \begin{flushright}
        \@author \\
        \@klass \\
        \ifnumgreater{\value{numjuhendajad}}{1}{Juhendajad:}{Juhendaja:}
        \newcommand*{\printjuh}[1]{##1 \\ }
        \forlistloop{\printjuh}{\juhendajalist}
    \end{flushright}
    \vfill
    \centerline{\@koht{} \the\year}
    \clearpage
    \normalsize
}

%--------------------------------------------------
%   KINNITUSLEHT
%--------------------------------------------------

\newcommand{\kinnitusleht}{%
    \addchap{Kinnitusleht}

    Uurimistöö autorina kinnitan, et
    \begin{itemize}
        \item koostasin uurimistöö iseseisvalt ning kõigile töös kasutatud teiste autorite töödele ja andme\-allikatele on viidatud;
        \item uurimistöö vastab Tallinna Reaalkooli uurimistöö juhendile;
        \item olen teadlik, et uurimistööd ei edastata teistele tulu teenimise eesmärgil ega jagata tead\-likult plagieerimiseks.
    \end{itemize}

    \vspace{1em}
    \dotfill

    kuupäev / nimi / allkiri

    \vspace{1.5cm}
    \noindent Juhendajana kinnitan, et uurimistöö vastab Tallinna Reaalkooli uurimistöö juhendile ja lubatakse kaitsmisele.

    Juhendaja

    \vspace{1em}
    \dotfill

    kuupäev / nimi / allkiri

    \vfill
}

%---------------------------------------------
%
%---------------------------------------------
