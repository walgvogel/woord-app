-- ============================================================
-- Audio Woord – Seed Data (echte cursusinhoud, pagina's 1–20)
-- Run AFTER schema.sql in Supabase SQL Editor
-- LET OP: verwijdert alle bestaande modules/lessen/oefeningen + submissions
-- ============================================================

-- ============================================================
-- BADGES
-- ============================================================

INSERT INTO badges (slug, name, description, icon_emoji) VALUES
  ('eerste-stem',    'Eerste Stem',     'Eerste opname ingediend',                  '🎤'),
  ('doorzetter',     'Doorzetter',      '3 pogingen op één oefening',               '🔁'),
  ('module-meester', 'Module Meester',  'Alle oefeningen van een module voltooid',  '⚡'),
  ('cursus-voltooid','Cursus Voltooid', 'Alle modules afgerond',                    '🏆'),
  ('luisteraar',     'Luisteraar',      '10 verschillende oefeningen voltooid',     '👂')
ON CONFLICT (slug) DO UPDATE
  SET name = EXCLUDED.name,
      description = EXCLUDED.description,
      icon_emoji = EXCLUDED.icon_emoji;

-- ============================================================
-- VERWIJDER BESTAANDE CURSUSDATA (cascade naar lessen/oefeningen/submissions)
-- ============================================================

DELETE FROM modules;

-- ============================================================
-- MODULE 1: Een krachtige stem
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('krachtige-stem', 'Een krachtige stem', '💪', 1);

-- ----------------------------------------------------------
-- Les 1.1: Oefening baart kunst
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'oefening-baart-kunst', 'Jouw stem is een spier — train hem!',
$$Spreken is topsport en dat vraagt training. Stel een trainingsschema op voor jezelf en maak het haalbaar. Het is alsof je een nieuwe taal leert. Wanneer je Spaans leert spreken moet je ook leren lispelen of zoals bij Frans je rollende Rrrrrr zoeken. Hoe krachtiger je articuleert, hoe verstaanbaarder je bent!

## Spreek pittig!

Onthoud dat je tong en je lippen een spier zijn. Net zoals je naar de fitness gaat voor stevige biceps, kan je ook je tong en lippen trainen!

> **Pittigheid:** Binnensmonds mompelen? Liever niet! Denk aan een beatboxer en geef je medeklinkers kracht door ze actief en scherp uit te spreken vooraan bij je lippen en tanden. Zo krijgt je stem meer power en luisteren mensen sneller naar wat je zegt.

## Lipronding

Zie je een **O**, **U** of een tweeklank waar een O of U in zit? Tuit dan je lippen alsof ze een O vormen. Zo duw je de letter meer naar buiten en klink je helderder.

> **Belangrijk!** Doe dit niet bij andere letters, anders lijk je net een vis.

### O (als in 'lot')

**Mondstand:** De lippen zijn lichtjes gerond, de tong ligt iets lager in de mond dan bij de I.

**Aandachtspunt:** In het West-Vlaams wordt de korte O soms meer gesloten uitgesproken, bijna als een U (Mus i.p.v. Mos).

### U (als in 'put')

**Mondstand:** De lippen zijn licht gerond, maar de mondopening blijft klein. De tong is iets omhoog en naar achteren geplaatst.

**Aandachtspunt:** De U wordt vaak te gesloten en achteraan gevormd (uh) — duw hem meer naar voren!

![klinkers O en U](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-klinkers-4.png)

![gymnast](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/stem-gymnast.png)$$, 1
FROM modules WHERE slug = 'krachtige-stem';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Pittigheidstest', 'self_assessment',
  'Lees de theorie over pittigheid. Spreek daarna luid de klinkers A – E – I – O – U uit en let op je mondstanden. Overdrijf bewust. Voel je het verschil? Klik op "Markeer als voltooid" wanneer je klaar bent.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'oefening-baart-kunst';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Lipronding: de O en OO', 'recording',
$$Woorden (kort): pot, klok, bos, hond, trots
Woorden (lang): boom, rood, brood, poot, droom

Zin 1 (O): De stomme hond sprong op de ronde ton.
Zin 2 (OO): Oom Joop kookte rode kool voor zijn zonen.
Zin 3 (Mix): De grote koster kocht een rode klok.$$, 2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'oefening-baart-kunst';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Lipronding: de U en UU', 'recording',
$$Woorden (kort): bus, put, mug, brug, druk
Woorden (lang): muur, vuur, puur, stuur, zuur

Zin 1 (U): De mug zoemt heel druk in de volle bus.
Zin 2 (UU): Ruud tuurt over de stenen muur naar het vuur.
Zin 3 (Mix): De zure buurman stuitert op de kruk.$$, 3
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'oefening-baart-kunst';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Lipronding: de OE', 'recording',
$$Woorden: boek, stoel, koe, snoep, roepen

Zin 1: De boer zoekt een goede schoen voor zijn voet.
Zin 2: De moedige poedel roept naar de koeien.$$, 4
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'oefening-baart-kunst';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Lipronding: de EU', 'recording',
$$Woorden: neus, deur, reus, leuk, kleur

Zin 1: De reus leunt tegen de gesloten deur.
Zin 2: De speurder snuift de geur van de nieuwe beuk.$$, 5
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'oefening-baart-kunst';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Lipronding: de UI', 'recording',
$$Woorden: huis, muis, uil, buiten, fluit

Zin 1: Buiten huilt de bruine uil bij het huis.
Zin 2: De luie muis kruipt door het vuile luik.$$, 6
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'oefening-baart-kunst';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Lipronding: de AU en OU', 'recording',
$$(Klank is hetzelfde, spelling is anders)
Woorden: koud, hout, blauw, pauw, vrouw

Zin 1: De blauwe pauw loopt in de kou over het hout.
Zin 2: De trotse vrouw vouwt de gouden mouw.$$, 7
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'oefening-baart-kunst';

-- ----------------------------------------------------------
-- Les 1.2: Pittig pittiger pittigst
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'tongtwisters', 'Pittig pittiger pittigst',
$$Tongtwisters zijn de fitness voor je tong en lippen. Begin altijd **langzaam** — zorg dat elke klank correct is. Verhoog dan stap voor stap de snelheid. Neem jezelf op en luister terug: ben je nog verstaanbaar?

> **Tip:** Overdrijf de medeklinkers. Zorg dat je ze vooraan in je mond vormt.

![peper](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/stem-peper.png)$$, 2
FROM modules WHERE slug = 'krachtige-stem';

-- 26 klassieke tongtwisters – elk apart opnemen

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'De klokkenluider luidt lang luidruchtige klokken', 'recording', NULL, 1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'De prins spreekt slecht spaans', 'recording', NULL, 2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'De kaka van een alpaca kan stevig stinken', 'recording', NULL, 3
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Die schaar knipt knap stroef', 'recording', NULL, 4
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Bas bakt blauwe boterkoeken', 'recording', NULL, 5
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Frits vindt visfrietjes vreselijk vies', 'recording', NULL, 6
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Rare ruige rapers rapen ruw rode raapjes en radijzen', 'recording', NULL, 7
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Ik ga mijn kersenpittenkussentje pakken', 'recording', NULL, 8
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Vier vieze varkens vreten veel vuilnis', 'recording', NULL, 9
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Ik schrijf scheef in mijn schrift', 'recording', NULL, 10
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Kleine kippen pikken kleine kuikens', 'recording', NULL, 11
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Bedek het bed met het dekbeddek', 'recording', NULL, 12
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Tien tamme tijgers trommelen op tinnen trommels', 'recording', NULL, 13
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'De poes kotst in de postzak', 'recording', NULL, 14
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Het heldere hemd hangt hoog', 'recording', NULL, 15
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'De kapster kapt de krullenbol op de kruk', 'recording', NULL, 16
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Nona kocht negen nieuwe nachtlampjes voor Nina''s nachttafel', 'recording', NULL, 17
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Papa pakt de blauwe platte bakpan', 'recording', NULL, 18
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Zeven schone schotse schaatsers schaatsen een scheve schaats in scheveningen', 'recording', NULL, 19
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Als achter vliegen vliegen vliegen, vliegen vliegen vliegen achterna', 'recording', NULL, 20
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Jeukt jouw jeukende neus ook zo als mijn jeukende neus jeukt', 'recording', NULL, 21
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Drie dove domme dromedarissen', 'recording', NULL, 22
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Als apen elkaar na-apen, apen apen apen na', 'recording', NULL, 23
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Max mixt de whiskey met de whiskeymixer', 'recording', NULL, 24
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Drie, droge, doeken', 'recording', NULL, 25
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Boterklontje boterklontje boterklontje', 'recording', NULL, 26
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

-- 9 articulatieoefeningen – elke Deel als één opname

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 1: De "Tippe-Tappe" variaties', 'recording',
$$Tippel trappel trappen top
Stippel stappel stappen stop
Tippel trappel trappen top top
Stippel stappel stappen stop stop

Pakken plakken pokken pok
Bakken blakken blokken blok
Kippen kappen kippen kop kop
Lippen lappen lippen lok lok

Pampers pimpen pompen pamp
Damme rammen dammen damp
Tamme rammen tamme tamp
Nummer rumoer nummer namp$$, 27
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 2: De labiale explosies', 'recording',
$$Bange boze buren bo
Pieker paker poken po
Brute broers braden braadworst brood
Prachtige prinsen proppen pruimen proost
Blauwe bloemen bloeien blij en bloot
Platte plannen plakken plots en plooit$$, 28
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 3: De "Ie-Aa-Oe" glijbaan', 'recording',
$$Mieren malen moeren moe
Dieren dalen doelen doe
Fieren falen voeren voe
Gieren galen goeder goe
Pieren palen poeder poe
Lier en laren loeren loe
Zielen zalen zoenen zoe$$, 29
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 4: Ritmisch staccato', 'recording',
$$Tiedelie, tiedelie, tiedelie tie tie
Ziedaar de, ziedaar de, ziedaar de zee zee
Wie was daar, wie was daar, wie was daar, wee wee$$, 30
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 5: De "Knisper-Knasper" tongbrekers', 'recording',
$$Knappe knapen knippen knopen knoop
Snelle snuiters snijden sneden snoep
Knappe knapen knippen knopen knoop
Snelle snuiters snijden sneden snoep

Spitsen spotten spinnenspotten spies
Stelen stallen stoelen stelen sties
Spitsen spotten spinnenspotten spies
Stelen stallen stoelen stelen sties$$, 31
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 6: De korte klappen', 'recording',
$$Tik de tin, ta! Tik de tin, ta! Tik de tin, ta, ta!
Pak de pin, pa! Pak de pin, pa! Pak de pin, pa, pa!
Tip de top, ta! Tip de top, ta! Tip de top, ta, ta!
Kip de kop, ka! Kip de kop, ka! Kip de kop, ka, ka!
Lik de lip, la! Lik de lip, la! Lik de lip, la, la!
Kit de kat, ka! Kit de kat, ka! Kit de kat, ka, ka!
Pit de pat, pa! Pit de pat, pa! Pit de pat, pa, pa!$$, 32
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 7: Het "Otteke" ritme', 'recording',
$$Zotteke zotten, zotteke zotten, zotteke zotten Ziet
Motteke motten, motteke motten, motteke motten Miel
Gokker de gokker, gokker de gokker, gokker de gokker Giek
Topper de topper, topper de topper, topper de topper Tiep$$, 33
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 8: De vochtige clusters', 'recording',
$$Stik de dikke drup drup, stik de dikke drup drup drup
Stok de dokken drip drip, stok de dokken drip drip drip
Stuk de dukken drep drep, stuk de dukken drep drep drep
Steile dijken driep driep, steile dijken driep driep driep$$, 34
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Deel 9: De grote finale', 'recording',
$$Flodder madammen, modder madammen, flop flop flee
Dronken madammen, kranken madammen, flop flop flee
Stabiele madammen, labiele madammen, flop flop flee
Blubber en bagger, snoever en sagger, flop flop flee

Fliere fluiter, stiekeme stuiter, stop stop stee
Vloer en vodden, stoken en doddlen, stop stop stee
Snebber en snavel, grabbel en navel, stop stop stee
Red wel die dikke dop, dikke dee!$$, 35
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters';

-- ----------------------------------------------------------
-- Les 1.3: Tips voor uitspraak
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'tips-uitspraak', 'Tips voor uitspraak',
$$## Tips om je uitspraak te verbeteren

### Opnemen & luisteren
Neem jezelf op tijdens het lezen. Luister terug en stel vragen: Welke woorden klinken onduidelijk? Verslik ik me in tempo? Slik ik klanken in? Detecteer je fouten en oefen die passages apart.

### Moeilijke woorden
Markeer moeilijke woorden in je tekst. Zoek de correcte uitspraak op en schrijf het woord fonetisch op ('zoals je het zegt'). Oefen het eerst in stukjes en spreek het daarna vloeiend uit.

### Leesritme
Begin met overdreven traag en duidelijk lezen. Versnel daarna stap voor stap. Zo train je controle: je leert verstaanbaar blijven, ook in een hoger tempo.

### Zet je oren open
Luister naar professionele stemmen (toneel, nieuwslezers, luisterboeken). Let op hoe zij klinkers vormen, hoe ze ademen en waar ze pauzes nemen.

### Beetje per beetje
Probeer niet alles tegelijk goed te doen. Focus eerst enkel op je 'a/aa'. Als dat goed gaat, neem je tweeklanken of andere klanken erbij.

### Betekenis
Oefen niet alleen de klanken, maar begrijp ook wat je leest. Als je de betekenis kent, spreek je het vanzelf zekerder en vloeiender uit.

### Spiegeltje spiegeltje aan de wand
Lees voor de spiegel. Kijk hoe je mond en tong bewegen. Zie je dat je klanken volledig vormt? Overdrijf gerust je mondstanden.

![spiegel](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/stem-spiegel.png)$$, 3
FROM modules WHERE slug = 'krachtige-stem';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Opnemen en terugluisteren', 'recording',
  'Lees de volgende zin 3 keer op, telkens iets sneller, en luister telkens terug. Let op: welke klanken klinken onduidelijk?

"De kapster kapt de krullenbol op de kruk terwijl de kaka van de alpaca stevig stinkt."',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tips-uitspraak';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Spiegeltje spiegeltje', 'self_assessment',
  'Lees een tekst naar keuze voor de spiegel. Kijk hoe je mond en tong bewegen. Zie je dat je klanken volledig vormt? Overdrijf bewust je mondstanden. Klik op "Markeer als voltooid" wanneer je klaar bent.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tips-uitspraak';

-- ----------------------------------------------------------
-- Les 1.4: Houding
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'houding', 'Houding',
$$## Wat is een goede houding?

> **Je benen staan evenwijdig met je heupen.**
> **Je gaat niet steunen op je tenen.**
> **Test: Kan je nog piano spelen met je tenen? Zo ja, dan sta je goed.**
> **Je staat recht en trekt je schouders niet naar achter.**
> **Je kaak, schouders en strottenhoofd zijn ontspannen.**

**TIP:** Als je leest sta dan niet in een 'leeshouding' waarbij de kin naar beneden is gericht. Hou je papier dan liever iets hoger op een bladhouder.

**Hoe ontspannen?** Geeuw, kijk dom (laat je onderkaak wat hangen), schud je schouders los.

![houding pinguïn](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/stem-houding-1.png)

![houding mens](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/stem-houding-2.png)$$, 4
FROM modules WHERE slug = 'krachtige-stem';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Houding controleren', 'self_assessment',
  'Ga staan en controleer elk punt: voeten evenwijdig met heupen, gewicht niet op de tenen, rug recht maar ontspannen, schouders los, kaak ontspannen. Kan je piano spelen met je tenen? Zo ja, dan sta je goed. Klik op "Markeer als voltooid" wanneer je de houding gecheckt hebt.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'houding';

-- ============================================================
-- MODULE 2: Ademhaling & Stemgebruik
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('ademhaling', 'Ademhaling & Stemgebruik', '🫁', 2);

-- ----------------------------------------------------------
-- Les 2.1: Buikademhaling
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'buikademhaling', 'Buikademhaling',
$$Als een baby huilt of spreekt, gebruikt hij automatisch de buik. Dat is natuurlijk en krachtig. Door stress leren we dit vaak af, terwijl we juist meer kracht krijgen als we vanuit de buik spreken. Bij buikademhaling activeren we terug ons middenrif bij het praten.

![buikademhaling](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/adem-buik.png)

## Stap 1: Bewust worden

> **Vraag jezelf af: Gaat mijn borst omhoog als ik adem? Of beweegt mijn buik?**

Voel op verschillende momenten:
- In de klas – Rechtstaan: waar voel ik de adem?
- Aan tafel – Zitten: waar voel ik de adem?
- In bed – Liggen: waar voel ik de adem?

## Stap 2: Ademhaling naar beneden halen

**Voelt je ademhaling hoog in je borst? Breng ze dan naar je buik.**

- Hand op buik
- Adem rustig in en uit
- Voel je buik uitzetten en terug zakken

**TIP:** Stel je voor dat er een neus boven je poep zit. Adem daar eens door.

## Stap 3: Spreken met je middenrif

**Waarom?** Je kan krachtiger, helderder en luider spreken — zonder dat je je stem forceert!

## Stap 4: Oefen met een woord: HOP!

- Zet je middenrif een beetje vast
- Zeg dan: "HOP!" – en bij de P laat je alles los
- Voel je de lucht terug naar je buik stromen?

## Stap 5: Oefen met een korte zin

Hetzelfde maar nu met een zin: **"Sta op!"** Laat weer los bij de P van "op". Ook hier moet je de lucht in je buik terug voelen stromen.

> **BELANGRIJK**
> - Haal de kracht uit je buik en middenrif, niet uit je kaak, nek, schouders of strottenhoofd.
> - Voel je spanning? Geeuw of laat je onderkaak hangen.
> - Begin nooit te happen naar adem — je hebt genoeg lucht in je longen.
> - Laat je mond na het spreken open zodat de lucht terug naar je buik kan stromen.$$, 1
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Bewust worden van je ademhaling', 'self_assessment',
  'Ga achtereenvolgens staan, zitten en liggen. Leg steeds een hand op je buik en een hand op je borst. Adem rustig. Welke hand beweegt het meest? Probeer de ademhaling naar je buik te brengen. Klik op "Markeer als voltooid" wanneer je de oefening gedaan hebt.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'buikademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Zeg HOP!', 'recording',
  'Doe de HOP-oefening en neem je stem op:
1. Zet je middenrif een beetje vast
2. Zeg "HOP!" – bij de P laat je alles los
3. Zeg dan "Sta op!" – voel de lucht bij de P van "op"
4. Zeg tot slot de weekdagen: maandag – dinsdag – woensdag – donderdag – vrijdag

Voel je de lucht bij elke P terug naar je buik stromen?',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'buikademhaling';

-- ----------------------------------------------------------
-- Les 2.2: Het middenrif
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'middenrif', 'Het middenrif',
$$Leg je hand net onder je ribben, op het zachte stukje boven je buik. Hoest eens. Of lach eens écht luid! Voel je iets bewegen onder je hand? Dat is je middenrif — de spier die je helpt ademen én krachtig praten.

## Stap 2: Wek je middenrif bewust op – via je stem!

Niet meer via een reflex (zoals hoesten), maar nu zelf gestuurd:

- Doe alsof je een kat wegjaagt: **"Kssssh!"**
- Of blaas een denkbeeldig veertje van je hand: **"Pfff!"**

Voel je dat korte duwtje bij je buik? Goed bezig! Dit noemen we: 'het loslaten van de adem'.

![kat](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/adem-kat.png)

## Stap 3: Krachtig en pittig!

> **Zeg: "FFFFF!" – Niet té lang, maar wel stevig. Laat daarna weer los.**

Voel je je middenrif bewegen in je buik? Dan gebruik je je middenrif goed! Pittig spreken en spreken met je middenrif zijn aan elkaar gelinkt!$$, 2
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Kssssh en Pfff', 'self_assessment',
  'Doe de oefening om je middenrif te voelen:
1. Leg een hand op je buik (net onder je ribben)
2. Doe alsof je een kat wegjaagt: "Kssssh!" — voel je het duwtje?
3. Blaas een denkbeeldig veertje van je hand: "Pfff!"
Herhaal 5 keer. Klik op "Markeer als voltooid" wanneer je het gevoel herkent.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'middenrif';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'FFFFF! – middenrifoefening', 'recording',
  'Neem jezelf op en doe de volgende oefening:
1. Zeg "FFFFF!" — stevig maar niet té lang, laat daarna los
2. Zeg "HOP!" — voel de lucht bij de P
3. Zeg "Sta op!" — en voel de lucht bij de P van "op"

Herhaal elke oefening 3 keer. Voel je middenrif bewegen?',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'middenrif';

-- ----------------------------------------------------------
-- Les 2.3: Spreek met je eigen stem
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'eigen-stem', 'Spreek met je eigen stem',
$$Je stem is lucht die je stembanden laat trillen. Iedereen heeft een andere stem, dus probeer die van jou niet te forceren. Hoe minder moeite je doet om te spreken, hoe beter en natuurlijker je klinkt.

## Focus op deze 3 stemtechnieken

### Toonhoogte

Vind je natuurlijke toonhoogte. Die ligt vaak iets lager dan waar je spontaan begint. Probeer niet te 'doen alsof' je een andere stem hebt.

Probeer eens de dagen van de week of tel eens tot 20. Wanneer je een tekst leest kan het goed zijn om eerst eens rustig en luidop tot drie te tellen.

### Buikademhaling

- Leg je hand op je buik
- Voel hoe je buik op en neer gaat als je ademt of spreekt
- Je gebruikt dan je adem goed, en je stem klinkt steviger

### Resonantie

Je lichaam is je klankkast, zoals bij een gitaar. Laat je stem meetrillen in je borst, neus en mond. Dan klinkt ze warmer en voller.

![gitaar](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/adem-gitaar.png)

> **Waarom?**
> - Je leert op jouw eigen toonhoogte spreken
> - Je stem klinkt rustiger, warmer en krachtiger
> - Je voorkomt dat je stem schel of geknepen klinkt
> - Je straalt meer rust en zelfvertrouwen uit$$, 3
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Toonhoogte vinden', 'recording',
  'Zoek je natuurlijke toonhoogte:
1. Tel rustig en luidop tot 20 — gebruik je gewone gesprekstem, niet te hoog
2. Zeg daarna de dagen van de week: maandag – dinsdag – woensdag – donderdag – vrijdag – zaterdag – zondag
3. Herhaal dit 3 keer

Klinkt je stem ontspannen en natuurlijk?',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'eigen-stem';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Resonantie voelen', 'self_assessment',
  'Doe de resonantie-oefening:
1. Sluit je lippen en maak een "Mmmm"-klank — voel je lippen en neusvleugels trillen
2. Open je mond en ga van "Mmmm" naar "Ma" — hou de trilling vast
3. Herhaal: Mmma – Mmme – Mmmi – Mmmo – Mmmu

Voel je het verschil in warmte en volume? Klik op "Markeer als voltooid".',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'eigen-stem';

-- ----------------------------------------------------------
-- Les 2.4: Zoemoefening
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'zoemoefening', 'Zoemoefening',
$$## Stap 1: Adem in met je 'poepneus'

> **Denk je in dat je een neus op je poep hebt (ja, echt).**

Adem eens diep in via die denkbeeldige neus. Dat helpt je om diep te ademen — in je buik, niet in je borst.

## Stap 2: Zoem vanuit je buik

**Maak een "mmmm"-klank.**

- Niet vanuit je hoofd
- Niet fluisterend
- Wel stevig, maar niet schreeuwend

Als je het goed doet, voel je je lippen en neusvleugels trillen. Dat is resonantie! Je stem 'vibreert' in je hoofd, net zoals een snaar in een gitaarkast.

## Stap 3: Laat je buik ademen

**Na het zoemen, hou je mond even open.**

Laat de lucht vanzelf terug je buik in stromen. Niet forceren. Gewoon laten gebeuren. Dit is buikademhaling (je gebruikt je middenrif). Herinner je de HOP-oefening? Dit is hetzelfde gevoel.

## Stap 4: Zoem en spreek

Zeg de dagen van de week: **"MMMMmaandag – dinsdag – woensdag…"**

Neem steeds een korte ademhaling tussen elke dag (dus niet alles op één adem zeggen!). Voel of je buik mee beweegt.

![bij](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/adem-bij.png)$$, 4
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Stappen 1–3: Mmmm-klank', 'recording',
  'Doe de eerste 3 stappen van de zoemoefening en neem ze op:
1. Adem in alsof je een neus op je poep hebt (diep in de buik)
2. Maak een stevige "Mmmm"-klank — voel je lippen en neus trillen?
3. Hou daarna je mond open, laat de lucht vanzelf terug

Herhaal 5 keer na elkaar.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'zoemoefening';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Stap 4: MMMMmaandag', 'recording',
  'Doe stap 4 van de zoemoefening:

Zeg: "MMMMmaandag – dinsdag – woensdag – donderdag – vrijdag – zaterdag – zondag"

Neem steeds een korte ademhaling na elke dag. Niet alles op één adem! Voel of je buik mee beweegt. Herhaal de hele reeks 3 keer.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'zoemoefening';

-- ----------------------------------------------------------
-- Les 2.5: Luid gaan met je stem
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'luid-gaan', 'Luid gaan met je stem',
$$Moet je gaan roepen? Op scène? Of omdat je voor een grote groep moet spreken? Haal dan de kracht vanuit je buik en middenrif als je luid wil gaan.

Zet die nooit op je kaak, schouders, strottenhoofd of nek! Last van spanning? Geeuw, kijk dom door je onderkaak wat open te laten hangen. Laat je schouders hangen, trek ze niet naar achter.

> **Tip! Probeer niet over de menigte te spreken, maar door.**
> **Probeer op een feest ook niet over maar DOOR de muziek te spreken.**

![tennis](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/adem-tennis.png)$$, 5
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Luid maar ontspannen', 'recording',
  'Spreek de volgende zinnen telkens luider op, maar let erop dat de kracht uit je buik komt en je keel, nek en schouders ontspannen blijven:

"JA!"
"KOM MAAR!"
"GOEDEMORGEN IEDEREEN!"

Ga van normaal volume naar presentatietoon. Voel je dat de kracht vanuit je middenrif komt?',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'luid-gaan';

-- ============================================================
-- MODULE 3: Een verzorgde uitspraak
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('uitspraak', 'Een verzorgde uitspraak', '🗣️', 3);

-- ----------------------------------------------------------
-- Les 3.1: Mondstanden – klinkers
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'mondstanden-klinkers', 'Mondstanden – klinkers',
$$Elke klinker vraagt om een andere mondstand. Twee sleutelwoorden: **openen** en **vooruit**. Open je mond voldoende (niet mompelen!) en laat je klanken echt naar buiten gaan — projecteer ze!

## Klinker per klinker

### A (als in 'kat')

**Mondstand:** De kaak zakt, de mond is redelijk wijd open. De tong ligt vrij plat in de mond.

**Aandachtspunt:** We hebben soms de neiging de "A" korter en meer gesloten te articuleren, bijna als een /ɔ/ (zoals in "bot").

![klinker a](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-klinkers-1.png)

### E (als in 'met')

**Mondstand:** De mond is iets minder open dan bij de A, en de tong ligt iets hoger.

**Aandachtspunt:** Pas op voor de vette E. Dat gebeurt wanneer de klank te gesloten wordt, zoals in het Engelse "back". Of de E wordt gesloten uitgesproken: /ə/ (de) of zelfs een /ɪ/ (dit).

![klinker e](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-klinkers-2.png)

### I (als in 'pit')

**Mondstand:** De mond is klein en gespannen, de tong is hoog in de mond.

**Aandachtspunt:** Let op dat de I niet te breed wordt uitgesproken (bijvoorbeeld "vies" in plaats van "vis"), en ook niet te kort ("ves" in plaats van "vis").

![klinker i](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-klinkers-3.png)

### O (als in 'lot')

**Mondstand:** De lippen zijn lichtjes gerond, de tong ligt iets lager in de mond dan bij de "I".

**Aandachtspunt:** In het West-Vlaams wordt de korte "O" soms meer gesloten uitgesproken, bijna als een /u/ (Mus).

> **Focus op ontronden:** Zie je een O, U of een tweeklank waar een O of U in staat? Tuit dan je lippen alsof ze een O vormen. Zo duw je de letter meer naar buiten. **Doe dit niet bij andere letters, anders lijk je net een vis.**

![klinker o](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-klinkers-4.png)

### U (als in 'put')

**Mondstand:** De lippen zijn licht gerond, maar de mondopening blijft klein. De tong is iets omhoog en naar achteren geplaatst.

**Aandachtspunt:** De "U" wordt vaak als een meer gesloten, achteraan gevormde klank uitgesproken (uh) — "Muhs" ipv. "Mus".

![klinker u](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-klinkers-5.png)

## En wat zijn tweeklanken dan?

**Tweeklanken** bestaan uit **twee klanken** waarbij de eerste klank verglijdt in de tweede. De beweging van de mond is hierbij belangrijk.

- **ij / ei:** je begint bij de [i], glijdt naar de [j]
- **ou / au:** je start bij de [o], glijdt naar de [w]
- **ui:** je begint bij de [u], glijdt naar de [j]$$, 1
FROM modules WHERE slug = 'uitspraak';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Klinker A – mondstand oefenen', 'recording',
  'Spreek de A-klank op met de juiste mondstand: kaak zakt, mond wijd open, tong plat.

Zeg: "aap – aarde – aan – bad – gat – kat – nat – pat – rat – zat"

Herhaal de reeks 3 keer. Overdrijf de mondstand bewust.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'mondstanden-klinkers';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Klinker E – mondstand oefenen', 'recording',
  'Spreek de E-klank op met de juiste mondstand: mond iets minder open dan A, tong iets hoger. Vermijd de vette E.

Zeg: "pet – bed – met – net – set – vet – lek – hek – keel – veel"

Herhaal de reeks 3 keer.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'mondstanden-klinkers';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Klinker I – mondstand oefenen', 'recording',
  'Spreek de I-klank op met de juiste mondstand: mond klein en gespannen, tong hoog. Niet te breed, niet te kort.

Zeg: "vis – pit – bit – dit – fit – hit – kit – list – mist – wist"

Herhaal de reeks 3 keer.',
  3
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'mondstanden-klinkers';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Klinker O – ontronden', 'recording',
  'Spreek de O-klank op: lippen lichtjes gerond, tuit ze naar voren. Focus op ontronden.

Zeg: "oog – oor – ook – boot – root – soot – voor – door – hoor – moor"

Herhaal de reeks 3 keer. Let op: tuit je lippen bij elke O.',
  4
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'mondstanden-klinkers';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Klinker U – ontronden', 'recording',
  'Spreek de U-klank op: lippen licht gerond maar mondopening klein, tong iets omhoog en naar achter. Tuit je lippen bij elke U.

Zeg: "put – mut – hut – nut – muts – buts – kuip – buik – tuin – duin"

Herhaal de reeks 3 keer.',
  5
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'mondstanden-klinkers';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Tweeklanken: ij, ou, ui', 'recording',
  'Spreek de tweeklanken op. Let op de beweging van de mond: van de eerste klank naar de tweede.

ij/ei: "ijs – bij – rij – mij – wijs – prijs – reizen – meisje"
ou/au: "oud – hout – goud – fout – blauw – gauw – dauw – rauw"
ui: "ui – huis – muis – tuin – buiten – fluiten – kuiken – buik"

Spreek elke reeks 2 keer op.',
  6
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'mondstanden-klinkers';

-- ----------------------------------------------------------
-- Les 3.2: Stemassimilatie
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'stemassimilatie', 'Stemassimilatie – Natuurlijk spreken',
$$Een West-Vlaming slikt al eens wat klanken in. **Bijvoorbeeld: boekn, patattn, kindrn…**

Dat is assimilatie: klanken verdwijnen of veranderen een beetje, zodat het vlotter klinkt. In het Standaardnederlands doen we dat ook — zeker als we hardop voorlezen of natuurlijk spreken.

## Stap 1: Respecteer leestekens — Je bent géén TGV!

- **Komma (,)** = korte pauze → zet er een V bij in je tekst
- **Punt (.)** = stop + adem → zet // in je tekst
- **Dubbele punt (:)** = korte pauze + nadruk op wat volgt
- Plan je ademhaling: las zelf ook pauzes in bij lange zinnen

> **Neem bij elke pauze rustig een adem in je buik.**
> Door leestekens en adempauzes te markeren, zorg je dat je tekst duidelijker klinkt, je stem krachtiger blijft en je niet buiten adem raakt.

![TGV trein](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-trein.png)

## Stap 2: Weglaten van de '-n' bij doffe e + n

- wallen**en**crème → walle**crème**
- schet**en** → schete
- droll**en** → drolle
- wolk**en**zee → wolkezee

**!! Let op:** Als er een klinker op volgt, blijft de -n wel staan. Voorbeeld: drollenexplosie → je zegt droll**en**explosie.

![assimilatie](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-assimilatie.png)

## Stap 3: De H van 'het', 'haar', 'hen', 'hun' mag wegvallen

Spreek je vlot? Dan mag je zeggen: *'t is mooi vandaag* in plaats van *het is mooi vandaag*.

**'Hij' wordt 'ie' (soms)** — als het in het midden van een zin staat. Speel ermee! Maar houd altijd de verstaanbaarheid in gedachten.

## Stap 4: Kappen vermijden

Wanneer je woorden los van elkaar uitspreekt, klinkt je stem haperend of geforceerd. Dat noemen we **"kappen"**.

**Wat doe je?** Zet met je pen een boogje tussen die twee woorden om ze vloeiend te verbinden.

**Voorbeeldzin:** "Pak een appel en eet die op."
→ Pak ↘ een ↘ appel ↘ en ↘ eet ↘ die op.

**!! Let op:** Woorden die beginnen met een klinker zijn vaak het risico. Daar "kap" je sneller.

![kapper](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-kappen.png)$$, 2
FROM modules WHERE slug = 'uitspraak';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Leestekens markeren', 'self_assessment',
  'Neem een willekeurige tekst (bijv. een artikel, de krant, een liedjestekst). Markeer:
- Een V bij elke komma (korte pauze)
- Een // bij elke punt (stop + adem)
Lees de tekst daarna luidop met die markeringen. Klinkt het duidelijker? Klik op "Markeer als voltooid" wanneer je dit gedaan hebt.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'stemassimilatie';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Doffe -n weglaten', 'recording',
  'Spreek de volgende woorden op. Laat de -n weg bij doffe e+n:

wallencrème → wallecrème
scheten → schete
drollen → drolle
wolkenzee → wolkezee

Spreek daarna de zin op: "De drollen van de dollen lagen verspreid over de natte stenen."

Let op: als er een klinker volgt, blijft de -n wel staan!',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'stemassimilatie';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Kappen vermijden', 'recording',
  'Spreek de volgende zinnen op zonder te "kappen" — verbind de woorden vloeiend:

"Pak een appel en eet die op."
"Het is altijd al even eerlijk."
"Een oude eik en een ijzeren hek."

Let op: woorden die beginnen met een klinker zijn het risico. Spreek elke zin 3 keer op.',
  3
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'stemassimilatie';

-- ----------------------------------------------------------
-- Les 3.3: Klemtonen en intonatie
-- ----------------------------------------------------------

INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'intonatie', 'Klemtonen en intonatie',
$$Wanneer we spreken, leggen we automatisch klemtonen op woorden om ze te benadrukken.

Dit kan op drie manieren: **met toonhoogte (melodisch accent)**, **tempo (temporeel accent)** of **volume (luidheidsaccent)**.

In gewone gesprekken gebeurt dit vanzelf, maar bij hardop lezen kunnen we er bewust op letten: welke woorden wil ik extra benadrukken?

## Tips voor een goede intonatie

### Let op de betekenis

De inhoud van de zin bepaalt hoe je hem zegt. Voorbeeld: "Vandaag heb ik zin in huiswerk." Je kan dit serieus, blij, of ironisch zeggen door toon, volume of tempo aan te passen.

Vandaag heb ik zin in huiswerk.
Vandaag heb **ik** zin in huiswerk.
Vandaag heb ik zin in **huiswerk**.
Vandaag heb ik **zin** in huiswerk.

![intonatie](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-intonatie.png)

### Vermijd dreunen of zingen
Bij rijm of kinderversjes spreek je vaak automatisch op dezelfde manier. Denk maar aan een klapspelletje dat je vanbuiten kent.

### Stijgende zinsklemtonen
Hoor je vaak bij kinderen en drukke sprekers. Past bij gevoelens van opwinding, enthousiasme en engagement.

### Een dalende intonatie
Wordt ervaren als ernstig, rustig en rustgevend. Past heel goed bij de overbrenging van zakelijke berichten.

### Varieer in intonatie
Gebruik niet steeds hetzelfde tempo, volume of toonhoogte, anders wieg je jouw publiek in slaap. Beklemtoon ook niet altijd het laatste woord.

### Moeilijke woorden
Door een woord te rekken of het met een kleine rust te accentueren geef je het extra aandacht. Dit doe je vooral met moeilijke woorden die de luisteraars voor de eerste keer te horen krijgen.

### Valse eindes
Laat de punten horen door ze erbij te denken. Als de mededeling af is, moet je dat ook laten horen.

### Uitdoven
Blijf doorspreken tot het einde van de zin. Laat de zin niet uitdoven door aan het einde te stil te gaan praten of door het laatste woord uit te rekken.

![kaars](https://lwynieygbodsizrzksqw.supabase.co/storage/v1/object/public/illustrations/uitspraak-kaars.png)$$, 3
FROM modules WHERE slug = 'uitspraak';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Klemtoon variëren', 'recording',
  'Spreek de zin "Vandaag heb ik zin in huiswerk" op vier verschillende manieren op. Leg telkens de klemtoon op een ander woord:

1. VANDAAG heb ik zin in huiswerk. (wanneer?)
2. Vandaag heb IK zin in huiswerk. (wie?)
3. Vandaag heb ik ZIN in huiswerk. (hoe?)
4. Vandaag heb ik zin in HUISWERK. (wat?)

Laat het verschil in betekenis duidelijk horen.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'intonatie';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Intonatie beoordelen', 'self_assessment',
  'Luister je opname van "Klemtoon variëren" opnieuw terug. Stel jezelf de volgende vragen:
- Hoor je duidelijk het verschil tussen de 4 versies?
- Klinkt je stem monotoon of varieert hij?
- Dooft de laatste zin uit, of blijf je doorspreken tot het einde?
Klik op "Markeer als voltooid" na je zelfevaluatie.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'intonatie';
