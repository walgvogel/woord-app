-- ============================================================
-- Audio Woord – Seed Data
-- Run AFTER schema.sql in Supabase SQL Editor
-- ============================================================

-- ============================================================
-- BADGES
-- ============================================================

INSERT INTO badges (slug, name, description, icon_emoji) VALUES
  ('eerste-stem',    'Eerste Stem',     'Eerste opname ingediend',                    '🎤'),
  ('doorzetter',     'Doorzetter',      '3 pogingen op één oefening',                 '🔁'),
  ('module-meester', 'Module Meester',  'Alle oefeningen van een module voltooid',    '⚡'),
  ('cursus-voltooid','Cursus Voltooid', 'Alle 5 modules afgerond',                   '🏆'),
  ('luisteraar',     'Luisteraar',      '10 verschillende oefeningen voltooid',       '👂')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- MODULE 1: Een krachtige stem
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('krachtige-stem', 'Een krachtige stem', '💪', 1)
ON CONFLICT (slug) DO NOTHING;

-- Lesson 1.1: Houding
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'houding', 'Houding & Uitstraling',
$$# Houding & Uitstraling

Een goede houding is de basis van een krachtige stem. Je lichaam is je instrument.

## Waarom houding belangrijk is

Wanneer je rechtop staat, kan je middenrif vrij bewegen en heb je voldoende ademruimte. Een slechte houding beperkt je stemgebruik.

> **Let op:** Controle altijd je houding voor je begint te spreken of opnemen.

## De ideale spreekhouding

- **Voeten** op schouderbreedte, gewicht gelijk verdeeld
- **Knieën** licht gebogen, niet vergrendeld
- **Rug** recht maar ontspannen
- **Schouders** naar achter en naar beneden
- **Kin** parallel aan de grond
- **Ogen** recht vooruit

## Oefening: De Houdings-check

Sta recht voor een spiegel. Controleer of je aan alle punten hierboven voldoet. Span je lichaam aan en laat het vervolgens los. Voel het verschil.

## Speciaal voor opnames

Bij het opnemen aan een microfoon:
- Sta of zit rechtop — nooit voorovergebogen
- Houd de microfoon op mondhoogte
- Blijf kalm en adem door je neus voor je begint
$$, 1
FROM modules WHERE slug = 'krachtige-stem';

-- Exercises for Houding
INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Houdings-check', 'self_assessment',
  'Controleer je houding volgens de punten in de les. Sta voor de spiegel en beoordeel jezelf. Klik op "Voltooid" wanneer je de oefening gedaan hebt.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'houding'
ON CONFLICT DO NOTHING;

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Zelfintroductie (staand)', 'recording',
  'Stel jezelf voor in 3 zinnen terwijl je in de correcte spreekhouding staat. Focus op een heldere, zelfzekere stem. Neem je introductie op.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'houding'
ON CONFLICT DO NOTHING;

-- Lesson 1.2: Articulatie
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'articulatie', 'Articulatie',
$$# Articulatie

Articulatie is de wijze waarop je klanken en woorden vormt met je mond, tong, lippen en tanden.

## Waarom articuleren?

Goede articulatie zorgt ervoor dat je boodschap duidelijk overkomt. Slechte articulatie leidt tot:
- Onduidelijk spreken ("sloffen")
- Miscommunicatie
- Onprofessioneel overkomen

## Articulatiespieren opwarmen

Doe elke ochtend (of voor een presentatie) deze warming-up:

1. **Lippen:** Pers ze op elkaar, laat los. Herhaal 10x.
2. **Wangen:** Blaas wangen op, laat lucht ontsnappen via de lippen. Herhaal 5x.
3. **Tong:** Rol de tong, strek hem uit, beweeg hem naar links en rechts.
4. **Kaak:** Open je mond zo wijd mogelijk, sluit langzaam. Herhaal 5x.

## De A-E-I-O-U oefening

Spreek elke klinker overdreven duidelijk uit. Overdrijf de mondstand:

**A** – mond wijd open
**E** – lippen naar de zijkanten
**I** – lippen breed, tanden zichtbaar
**O** – lippen gerond, naar voren
**U** – lippen sterk gerond en naar voren

> **Tip:** Overdrijf bij de oefening. In de praktijk kom je automatisch op het juiste midden uit.
$$, 2
FROM modules WHERE slug = 'krachtige-stem';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'A-E-I-O-U Warming-up', 'recording',
  'Spreek de klinkers A, E, I, O, U luid en duidelijk uit. Overdrijf de mondstanden. Herhaal de reeks 3 keer na elkaar in één opname.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'articulatie'
ON CONFLICT DO NOTHING;

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Zin met alle klinkers', 'recording',
  'Spreek de volgende zin duidelijk uit: "Aap eet ijs op een oude urn." Herhaal 3x, elke keer iets sneller maar altijd verstaanbaar.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'articulatie'
ON CONFLICT DO NOTHING;

-- Lesson 1.3: Tongtwisters
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'tongtwisters', 'Tongtwisters',
$$# Tongtwisters

Tongtwisters zijn korte zinnen die specifieke klankcombinaties bevatten die moeilijk snel uit te spreken zijn.

## Waarvoor dienen tongtwisters?

- Articulatiespieren trainen
- Concentratie op klanken
- Vlottheid en snelheid opbouwen
- Opwarmen voor presentaties of opnames

## Basistongtwisters (Nederlands)

**Niveau 1 – Langzaam**
> Als vliegen achter vliegen vliegen, vliegen vliegen vliegen achterna.

> De kat krabt de krullen van de trap.

**Niveau 2 – Middelmatig**
> Zij schilt zes zalmen en zes schollen.

> De koetsier poetst de postkoets.

**Niveau 3 – Snel**
> Hoe hard het harnas hart ook klonk, de hansop spong erop en zonk.

## Techniek

1. Begin **zeer langzaam** – zorg dat elke klank correct is
2. Verhoog de snelheid **stap voor stap**
3. Neem de twisters op en luister terug: zijn ze verstaanbaar?

> **Uitdaging:** Probeer niveau 3 3x achter elkaar zonder fouten!
$$, 3
FROM modules WHERE slug = 'krachtige-stem';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Tongtwister niveau 1', 'recording',
  'Spreek de tongtwister "Als vliegen achter vliegen vliegen, vliegen vliegen vliegen achterna" 3x uit: eerst langzaam, dan normaal, dan snel.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters'
ON CONFLICT DO NOTHING;

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Tongtwister uitdaging', 'recording',
  'Kies één van de niveau 3 tongtwisters. Probeer hem 3x achter elkaar op te nemen zonder fouten. Hoe snel kun je gaan terwijl je verstaanbaar blijft?',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'krachtige-stem' AND l.slug = 'tongtwisters'
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 2: Ademhaling & Stemgebruik
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('ademhaling', 'Ademhaling & Stemgebruik', '🫁', 2)
ON CONFLICT (slug) DO NOTHING;

-- Lesson 2.1: Buikademhaling
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'buikademhaling', 'Buikademhaling',
$$# Buikademhaling

De meeste mensen ademen te oppervlakkig – met de borst. Buikademhaling (diafragmatisch ademen) is de basis van een krachtige, gedragen stem.

## Borstademhaling vs. Buikademhaling

| Borstademhaling | Buikademhaling |
|-----------------|----------------|
| Oppervlakkig | Diep |
| Schouders omhoog | Buik naar voren |
| Minder lucht | Meer luchtcapaciteit |
| Stemt vermoeit snel | Langere zinnen mogelijk |

## De techniek

1. Leg een hand op je buik, de andere op je borst
2. Adem in via de neus – de **buikhand** beweegt naar voren, de borsthand blijft stil
3. Adem uit via de mond – de buik gaat terug

> **Tip:** Oefen liggend op de rug. Dan voelt het verschil meteen.

## Ademhalingsoefening: 4-7-8

- Adem in gedurende **4** tellen
- Houd de adem vast gedurende **7** tellen
- Adem uit gedurende **8** tellen

Herhaal 4 keer. Dit kalmeer ook het zenuwstelsel voor opnames.
$$, 1
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Buikademhaling voelen', 'self_assessment',
  'Leg een hand op je buik. Adem 5x diep in en uit via de neus. Beweegt je buik naar voren bij het inademen? Klik "Voltooid" als je de oefening gedaan hebt.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'buikademhaling'
ON CONFLICT DO NOTHING;

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, '4-7-8 Ademhalingsoefening', 'recording',
  'Neem de 4-7-8 ademhalingsoefening op. Spreek de tellingen hardop uit (bv. "in: 1-2-3-4, houd: 1-2-3-4-5-6-7, uit: 1-2-3-4-5-6-7-8"). Herhaal 3 cycli.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'buikademhaling'
ON CONFLICT DO NOTHING;

-- Lesson 2.2: Resonantie
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'resonantie', 'Resonantie & Stemkleur',
$$# Resonantie & Stemkleur

Resonantie bepaalt de "kleur" en het volume van je stem. Je lichaam fungeert als een klankkast.

## Wat is resonantie?

Wanneer je spreekt, trillen je stembanden. Die trillingen worden versterkt door holtes in je lichaam:
- **Borstholte** → warme, lage klanken
- **Mondholte** → heldere middenfrequenties
- **Neusholte** → nasale klanken

## De "Mmm"-oefening

1. Sluit je lippen en zeg "Mmm"
2. Voel de trilling in je lippen en neus
3. Verhoog langzaam de toon: "Mmmm↑"
4. Verlaag de toon: "Mmmm↓"

Voel hoe de trilling verplaatst van neus naar borst.

## Van "Mmm" naar woorden

- Mmm → **Ma** – **Me** – **Mi** – **Mo** – **Mu**
- Herhaal met verhoogde volume
- Houd de resonantie vast van de "Mmm" bij de klinker

> **Doel:** Je stem klinkt warmer, voller en draagt beter in grotere ruimtes.
$$, 2
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Mmm-resonantie oefening', 'recording',
  'Doe de Mmm-oefening: begin met een zachte "Mmm", ga dan over naar "Ma-Me-Mi-Mo-Mu". Herhaal de reeks 3x, elke keer met meer resonantie en volume.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'resonantie'
ON CONFLICT DO NOTHING;

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Tekst met resonantie', 'recording',
  'Lees de volgende zin voor met maximale resonantie: "De mooie melodie weerklonk door de massieve muren van het middeleeuwse monument." Focus op de M-klanken.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'resonantie'
ON CONFLICT DO NOTHING;

-- Lesson 2.3: Stemvolume
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'stemvolume', 'Stemvolume & Draagkracht',
$$# Stemvolume & Draagkracht

Een stem die goed draagt hoeft niet per se luid te zijn. Stemkracht komt van techniek, niet van schreeuwen.

## Volume vs. Kracht

- **Volume** = hoe luid je spreekt (decibel)
- **Kracht** = hoe ver je stem draagt (combinatie van resonantie, articulatie, ademhaling)

Een goed gearticuleerde, resonante stem draagt verder dan een luide maar onduidelijke stem.

## Dynamisch stemgebruik

Varieer je volume bewust:
- **Zacht** voor intieme momenten of om aandacht te trekken
- **Normaal** voor gewone conversatie
- **Luid** voor nadruk of grote ruimtes

## Oefening: Volume-schaal

Spreek de volgende zin op 5 niveaus uit (fluister → luid):
> "Vandaag ga ik iets vertellen wat echt belangrijk is."

Level 1: fluistertoon
Level 2: zacht
Level 3: normaal gesprekstoon
Level 4: presentatietoon
Level 5: theater/grote zaal
$$, 3
FROM modules WHERE slug = 'ademhaling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Volume-schaal oefening', 'recording',
  'Spreek de zin "Vandaag ga ik iets vertellen wat echt belangrijk is" op 5 volumelevels achter elkaar in: van fluistertoon tot theatertoon. Benoem elk level.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'ademhaling' AND l.slug = 'stemvolume'
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 3: Een verzorgde uitspraak
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('uitspraak', 'Een verzorgde uitspraak', '🗣️', 3)
ON CONFLICT (slug) DO NOTHING;

-- Lesson 3.1: Klinkers
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'klinkers', 'Klinkers & Mondstanden',
$$# Klinkers & Mondstanden

De Nederlandse taal kent 13 klinkers. Een verzorgde uitspraak vereist dat je de juiste mondstand aanneemt voor elke klinker.

## De 13 Nederlandse klinkers

**Korte klinkers:** a, e, i, o, u
**Lange klinkers:** aa, ee, ie, oo, uu, eu, oe
**Tweeklanken:** ei/ij, ui, au/ou

## Mondstanden

| Klinker | Mondstand | Voorbeeld |
|---------|-----------|-----------|
| a / aa | Mond wijd open | **a**ап, **aa**n |
| e / ee | Mond half open, lippen iets gespreid | **e**k, **ee**n |
| i / ie | Mond smal, lippen breed | **i**n, **ie**der |
| o / oo | Mond half open, gerond | **o**p, **oo**g |
| u / uu | Mond gerond, vooruit | **u**niform, **uu**r |

## Oefentekst klinkers

> "Ik eet elke ochtend een appel of een ei uit de oven."

Spreek de klinkers overdreven duidelijk uit.
$$, 1
FROM modules WHERE slug = 'uitspraak';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Klinkerrij oefening', 'recording',
  'Spreek alle 5 korte en 7 lange klinkers duidelijk uit (a-e-i-o-u / aa-ee-ie-oo-uu-eu-oe). Neem hierna de oefenzin op: "Ik eet elke ochtend een appel of een ei uit de oven."',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'klinkers'
ON CONFLICT DO NOTHING;

-- Lesson 3.2: Intonatie
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'intonatie', 'Intonatie & Zinsintonatie',
$$# Intonatie & Zinsintonatie

Intonatie is de melodie van je spraak – hoe je toon stijgt en daalt doorheen een zin.

## Waarom intonatie?

Zonder intonatie klinkt je stem monotoon en saai. Goede intonatie:
- Houdt de luisteraar geboeid
- Geeft aan wat belangrijk is
- Maakt je boodschap begrijpelijker

## Soorten zinsintonatie

**Mededelende zin** → toon daalt aan het einde
> "Het regent vandaag." ↘

**Vraagzin (ja/nee)** → toon stijgt aan het einde
> "Regent het vandaag?" ↗

**Vraagzin (open)** → toon daalt (of neutraal)
> "Wanneer regent het?" ↘

## Nadruk

Nadruk plaatsen op een woord verandert de betekenis:

> **Ik** ga morgen → Ik ga, niet iemand anders
> Ik ga **morgen** → Niet vandaag, maar morgen
> Ik **ga** morgen → Ik ga echt, hoor!
$$, 2
FROM modules WHERE slug = 'uitspraak';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Zinsintonatie oefening', 'recording',
  'Spreek de zin "Marie koopt morgen een nieuwe fiets" op 3 manieren uit: met nadruk op "Marie", dan op "morgen", dan op "nieuwe". Laat het verschil horen.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'intonatie'
ON CONFLICT DO NOTHING;

-- Lesson 3.3: Assimilatie
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'assimilatie', 'Assimilatie & Verbindingsklanken',
$$# Assimilatie & Verbindingsklanken

Assimilatie is het verschijnsel waarbij klanken elkaars uitspraak beïnvloeden in vloeiende spraak.

## Wat is assimilatie?

In normaal spraakgebruik worden bepaalde klanken aangepast aan naburige klanken:

- **"zakdoek"** → klinkt als "zagdoek" (de k wordt g voor de d)
- **"hebben"** → klinkt als "hebbe" (de n valt weg in informele spraak)

## Soorten assimilatie

**Regressieve assimilatie:** de latere klank beïnvloedt de eerdere
> "ik ben" → "ig ben"

**Progressieve assimilatie:** de eerdere klank beïnvloedt de latere
> "zakboek" → "zagboek"

## Wanneer wel/niet assimileren?

| Formeel (presentatie, media) | Informeel (gesprek) |
|------------------------------|---------------------|
| Zorgvuldige uitspraak | Assimilatie toegestaan |
| Eindklanken duidelijk | Verbindingsklanken wegvallen |

> **Regel:** In professionele opnames: zorgvuldig en duidelijk articuleren.
$$, 3
FROM modules WHERE slug = 'uitspraak';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Formele vs. informele uitspraak', 'recording',
  'Spreek de zin "Ik heb de zakdoek in mijn zak gestopt" tweemaal uit: eerst in informele spreektaal (met assimilaties), dan in formeel en zorgvuldig Nederlands.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'uitspraak' AND l.slug = 'assimilatie'
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 4: Audio & Opname
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('audio', 'Audio & Opname', '🎙️', 4)
ON CONFLICT (slug) DO NOTHING;

-- Lesson 4.1: Opnametips
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'opnametips', 'Opnametips & Techniek',
$$# Opnametips & Techniek

Een goede opname vereist meer dan alleen goed spreken. De omgeving en techniek spelen een belangrijke rol.

## De ideale opnameomgeving

**Vermijd:**
- Harde, reflecterende oppervlakken (tegels, glas)
- Achtergrondgeluid (ventilatie, verkeer, gesprekken)
- Echo (grote, lege ruimtes)

**Kies voor:**
- Kleine, gestoffeerde ruimtes (slaapkamer, kledingkast!)
- Zachte materialen (gordijnen, tapijt, kussens) absorberen echo
- 's Avonds of 's nachts: minder omgevingslawaai

## Microfoon-techniek

- Houd de microfoon **15-20 cm** van je mond
- Spreek **niet rechtstreeks** in de microfoon maar er lichtjes naast (om popping te vermijden)
- Gebruik een **popfilter** als dat beschikbaar is

## De Zoom H5

De Zoom H5 is een draagbare recorder:
1. Zet hem aan (power-knop zijkant)
2. Selecteer input (ingebouwde microfoon of XLR)
3. Stel gain in (meter moet pieken rond -12 dB)
4. Druk op REC om te beginnen

## De Rødecaster Pro

De Rødecaster is een professionele productietafel:
- Meerdere kanalen tegelijk opnemen
- Ingebouwde effecten (EQ, compressor)
- USB-aansluiting op laptop

> **Gouden regel:** Doe altijd een testopname van 30 seconden en luister terug voor je begint met de echte opname.
$$, 1
FROM modules WHERE slug = 'audio';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Opname-omgeving beoordelen', 'self_assessment',
  'Zoek een geschikte opnameomgeving op in je huis of school. Maak een testopname van 10 seconden (spreek gewoon wat tekst). Luister terug: is er echo? Achtergrondgeluid? Klik "Voltooid" na de test.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'audio' AND l.slug = 'opnametips'
ON CONFLICT DO NOTHING;

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Professionele testopname', 'recording',
  'Maak een opname van 30 seconden in de best mogelijke omgeving die je kunt vinden. Spreek de tekst: "Dit is een testopname van [jouw naam]. Ik test de akoestiek van deze ruimte. Let op de helderheid en de eventuele echo." Luister kritisch terug.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'audio' AND l.slug = 'opnametips'
ON CONFLICT DO NOTHING;

-- Lesson 4.2: Microfoongebruik
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'microfoongebruik', 'Microfoongebruik',
$$# Microfoongebruik

Het correct gebruiken van een microfoon is een vaardigheid op zich.

## Soorten microfoons

**Dynamische microfoon** (bv. Shure SM58)
- Robuust, geschikt voor live gebruik
- Minder gevoelig voor omgevingsgeluid

**Condensatormicrofoon** (bv. rode NT1)
- Hoge gevoeligheid, rijke klankkwaliteit
- Vereist phantomvoeding (+48V)
- Pikt meer omgevingsgeluid op

**Lavalier/dasspeld** (bv. Rode Wireless GO)
- Klein, bevestigd aan kleding
- Handig voor bewegende sprekers

## Popklanken vermijden

Plosieven (p, b, t, d) veroorzaken "popping" in opnames. Vermijd dit:
- Gebruik een popfilter
- Spreek lichtjes naast de microfoon (45° hoek)
- Vergroot de afstand bij p- en b-klanken

## Gain instellen

Te weinig gain → fluisterstille opname, veel ruis bij versterken
Te veel gain → vervorming (clipping)

**Ideale niveau:** pieken rond -12 tot -6 dB, nooit boven 0 dB (rood)

> **Oefening:** Doe een soundcheck van 30 seconden en pas de gain aan voor je begint met opnemen.
$$, 2
FROM modules WHERE slug = 'audio';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'P-klanken oefening', 'recording',
  'Neem op: "Peter pakte per post prachtige pakketjes." Spreek dit 3x uit en probeer popping van de p-klanken te vermijden door lichtjes naast de microfoon te spreken.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'audio' AND l.slug = 'microfoongebruik'
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 5: Storytelling
-- ============================================================

INSERT INTO modules (slug, title, icon, "order") VALUES
  ('storytelling', 'Storytelling', '📖', 5)
ON CONFLICT (slug) DO NOTHING;

-- Lesson 5.1: Verhaalstructuur
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'verhaalstructuur', 'Verhaalstructuur',
$$# Verhaalstructuur

Een goed verhaal heeft een herkenbare structuur. Of het nu een persoonlijk verhaal is, een presentatie of een podcast-item – structuur houdt je publiek geboeid.

## De klassieke structuur

**Drieluik:**
1. **Begin** – Stel de wereld voor. Wie? Waar? Wanneer?
2. **Midden** – Het conflict of de uitdaging. Wat gaat er mis of verandert er?
3. **Einde** – De oplossing, de les, de conclusie.

## De Pixar-formule

> "Er was eens ___. Elke dag ___. Totdat op een dag ___. Daardoor ___. Totdat uiteindelijk ___. En sindsdien ___."

## Spanningsboog opbouwen

- Begin **in medias res** (midden in de actie)
- Gebruik **concrete details** (niet "een groot huis" maar "een rood herenhuis met een gebarsten voordeur")
- Bouw op naar een **hoogtepunt**
- Sluit af met een **echo** van het begin

> **Oefening:** Vertel een verhaal van 2 minuten over iets grappigs of spannends dat je ooit is overkomen. Gebruik de Pixar-formule.
$$, 1
FROM modules WHERE slug = 'storytelling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Pixar-formule verhaal', 'recording',
  'Vertel een persoonlijk verhaal van 1-2 minuten aan de hand van de Pixar-formule: "Er was eens... Elke dag... Totdat op een dag... Daardoor... Totdat uiteindelijk... En sindsdien..." Gebruik concrete details.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'storytelling' AND l.slug = 'verhaalstructuur'
ON CONFLICT DO NOTHING;

-- Lesson 5.2: Show don't tell
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'show-dont-tell', 'Show Don''t Tell',
$$# Show Don't Tell

"Show don't tell" is het principe waarbij je de luisteraar iets laat **ervaren** in plaats van het te **vertellen**.

## Het verschil

**Vertellen (telling):**
> "Hij was heel erg boos."

**Tonen (showing):**
> "Zijn kaken waren op elkaar geklemd. Hij legde zijn telefoon neer met een klap die door het hele kantoor klonk."

## Waarom tonen werkt

- Luisteraars/lezers voelen meer betrokkenheid
- Het is concreter en geloofwaardiger
- Het activeert de verbeelding

## Sensoriële details

Gebruik alle zintuigen:
- **Zicht:** wat zie je?
- **Gehoor:** wat hoor je?
- **Geur:** wat ruik je?
- **Smaak:** wat proef je?
- **Tastgevoel:** wat voel je?

## Oefening

Herschrijf deze "telling"-zin naar "showing":
> "Het was een mooie zomeravond."

Mogelijke showing-versie:
> "De zon zakte traag achter de daken. Ergens speelde een kind met een bal. Door het open raam kwam een zuchtje wind dat rook naar vers gemaaid gras."
$$, 2
FROM modules WHERE slug = 'storytelling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Show don''t tell opname', 'recording',
  'Beschrijf een plek die je goed kent (kamer, plek in de natuur, school) door te tonen, niet te vertellen. Gebruik alle 5 zintuigen. Duur: 60-90 seconden. Gebruik GEEN woorden als "mooi", "leuk", "saai".',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'storytelling' AND l.slug = 'show-dont-tell'
ON CONFLICT DO NOTHING;

-- Lesson 5.3: Stemgebruik in storytelling
INSERT INTO lessons (module_id, slug, title, content, "order")
SELECT id, 'stem-in-storytelling', 'Stem in Storytelling',
$$# Stem in Storytelling

Bij het vertellen van een verhaal is je stem het belangrijkste instrument. Hoe je iets zegt is minstens even belangrijk als wat je zegt.

## Stemtechnieken voor storytelling

**Pauze**
Een pauze op het juiste moment creëert spanning, geeft de luisteraar tijd om te verwerken en benadrukt wat volgt.

> "En toen... [pauze van 3 seconden] ...was hij weg."

**Tempo variëren**
- Snel vertellen = opwinding, actie, chaos
- Langzaam vertellen = spanning, gewicht, emotie

**Toon en kleur**
- Stem omlaag = seriositeit, gevaar
- Stem omhoog = verrassing, vraag, vreugde

**Personages**
Geef elk personage een eigen stem: iets hoger, lager, trager, sneller.

## De kracht van stilte

Angst voor stilte is normaal, maar stilte is krachtig. Train jezelf om comfortabel te zijn met pauzes van 2-3 seconden.

> **Oefening:** Vertel een verhaal van 2 minuten. Gebruik minstens 3 bewuste pauzes van 2+ seconden. Wissel tempo af.
$$, 3
FROM modules WHERE slug = 'storytelling';

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Verhaal met stemtechnieken', 'recording',
  'Vertel een verhaal (zelfgekozen of fictief) van 2 minuten. Gebruik minstens: 3 bewuste pauzes, 2 tempowisselingen, 1 stemwisseling voor een personage. Luister terug en noteer wat je goed deed.',
  1
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'storytelling' AND l.slug = 'stem-in-storytelling'
ON CONFLICT DO NOTHING;

INSERT INTO exercises (lesson_id, title, type, instructions, "order")
SELECT l.id, 'Zelfreflectie storytelling', 'self_assessment',
  'Luister je opname van "Verhaal met stemtechnieken" opnieuw. Noteer (in je hoofd of op papier): Welke techniek werkte het best? Wat wil je verbeteren? Klik "Voltooid" na de reflectie.',
  2
FROM lessons l JOIN modules m ON m.id = l.module_id
WHERE m.slug = 'storytelling' AND l.slug = 'stem-in-storytelling'
ON CONFLICT DO NOTHING;
