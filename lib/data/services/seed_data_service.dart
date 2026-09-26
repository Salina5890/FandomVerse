import 'package:get/get.dart';
import '../models/fandom_model.dart';
import '../models/content_model.dart';
import '../models/event_model.dart';
import '../models/product_model.dart';
import '../models/misc_models.dart';
import '../models/cart_models.dart';
import '../models/user_model.dart';
import '../../app/constants/app_constants.dart';

/// Provides realistic mock/seed data for the Fandom Verse application.
/// This data is used in place of Firebase during development / UI-first build.
class SeedDataService extends GetxService {
  // ──────────────────────────────────────────────────────────
  // USERS
  // ──────────────────────────────────────────────────────────
  static UserModel get demoFan => UserModel(
        id: 'fan_001',
        email: 'demo@fandomverse.app',
        name: 'Sakura Kim',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
        bio:
            'Hardcore anime fan & K-Pop devotee. I live for the lore.',
        role: 'fan',
        selectedFandomIds: ['f1', 'f2', 'f4', 'f6'],
        badgeIds: ['b1', 'b3', 'b5'],
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now(),
      );

  static UserModel get demoAdmin => UserModel(
        id: 'admin_001',
        email: AppConstants.adminDemoEmail,
        name: 'Alex Verse',
        role: 'admin',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      );

  // ──────────────────────────────────────────────────────────
  // FANDOMS
  // ──────────────────────────────────────────────────────────
  static final List<FandomModel> _fandomsCache = [

        FandomModel(
          id: 'f1',
          name: 'Attack on Titan',
          description:
              'Humanity\'s last stand against the monstrous Titans. An epic saga of freedom, war, and sacrifice that redefines anime storytelling.',
          category: 'Anime',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Attack_on_Titan.jpg/800px-Attack_on_Titan.jpg',
          tags: ['action', 'dark', 'war', 'titans', 'military'],
          isFeatured: true,
          memberCount: 2_400_000,
          createdAt: DateTime.now().subtract(const Duration(days: 300)),
          updatedAt: DateTime.now(),
        ),
        FandomModel(
          id: 'f2',
          name: 'BTS Universe',
          description:
              'The global phenomenon that is BTS — ARMY culture, lyrics analysis, comeback countdowns, and everything in between.',
          category: 'K-Pop',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/BTS_Arirang_World_Tour_in_Paris_%2817_July_2026%29_-_finale.jpg/960px-BTS_Arirang_World_Tour_in_Paris_%2817_July_2026%29_-_finale.jpg',
          tags: ['k-pop', 'music', 'army', 'comeback', 'idol'],
          isFeatured: true,
          memberCount: 5_100_000,
          createdAt: DateTime.now().subtract(const Duration(days: 280)),
          updatedAt: DateTime.now(),
        ),
        FandomModel(
          id: 'f3',
          name: 'Cyberpunk Universe',
          description:
              'Neon-soaked dystopian futures — from 2077 to the Edge Runners. Explore the lore, character backstories, and tech breakdowns.',
          category: 'Gaming',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/PGA_2019_Cyberpunk_2077.jpg/960px-PGA_2019_Cyberpunk_2077.jpg',
          tags: ['cyberpunk', 'rpg', 'sci-fi', 'neon', 'dystopian'],
          isFeatured: false,
          memberCount: 890_000,
          createdAt: DateTime.now().subtract(const Duration(days: 240)),
          updatedAt: DateTime.now(),
        ),
        FandomModel(
          id: 'f4',
          name: 'Demon Slayer',
          description:
              'Tanjiro\'s journey through a world of demons and Hashira. Stunning visuals, emotional depth, and legendary battles.',
          category: 'Anime',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Cosplay_de_Kokushibo_Demon_slayer.jpg/454px-Cosplay_de_Kokushibo_Demon_slayer.jpg',
          tags: ['anime', 'demons', 'samurai', 'hashira', 'tanjiro'],
          isFeatured: true,
          memberCount: 1_800_000,
          createdAt: DateTime.now().subtract(const Duration(days: 200)),
          updatedAt: DateTime.now(),
        ),
        FandomModel(
          id: 'f5',
          name: 'Marvel Cinematic',
          description:
              'The entire MCU at your fingertips — origin stories, multiverse theories, and everything from Iron Man to the latest Phase.',
          category: 'Movies',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Marvel_characters.jpg/960px-Marvel_characters.jpg',
          tags: ['marvel', 'avengers', 'mcu', 'superheroes', 'comics'],
          isFeatured: false,
          memberCount: 3_200_000,
          createdAt: DateTime.now().subtract(const Duration(days: 180)),
          updatedAt: DateTime.now(),
        ),
        FandomModel(
          id: 'f6',
          name: 'BLACKPINK',
          description:
              'BLINKS unite — concert recaps, choreography breakdowns, album analysis, and all things BLACKPINK.',
          category: 'K-Pop',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Blackpink.jpg/960px-Blackpink.jpg',
          tags: ['k-pop', 'blackpink', 'blink', 'music', 'fashion'],
          isFeatured: false,
          memberCount: 4_700_000,
          createdAt: DateTime.now().subtract(const Duration(days: 160)),
          updatedAt: DateTime.now(),
        ),
        FandomModel(
          id: 'f7',
          name: 'One Piece',
          description:
              'A pirate\'s journey across the Grand Line — 1000+ chapters of lore, Devil Fruits, and the quest for the legendary treasure.',
          category: 'Anime',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/One_Piece_%288413847339%29.jpg/960px-One_Piece_%288413847339%29.jpg',
          tags: ['anime', 'pirate', 'grandline', 'devil-fruit', 'luffy'],
          isFeatured: false,
          memberCount: 2_900_000,
          createdAt: DateTime.now().subtract(const Duration(days: 150)),
          updatedAt: DateTime.now(),
        ),
        FandomModel(
          id: 'f8',
          name: 'Halo Universe',
          description:
              'From the Covenant War to the Created conflict — explore the UNSC, Forerunners, and everything in the Halo ring universe.',
          category: 'Gaming',
          coverImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Halo_MCC_banner.jpg/960px-Halo_MCC_banner.jpg',
          tags: ['halo', 'fps', 'spartan', 'sci-fi', 'covenant'],
          isFeatured: false,
          memberCount: 640_000,
          createdAt: DateTime.now().subtract(const Duration(days: 130)),
          updatedAt: DateTime.now(),
        ),
      ];
  static List<FandomModel> get fandoms => _fandomsCache;


  // ──────────────────────────────────────────────────────────
  // CONTENT
  // ──────────────────────────────────────────────────────────
  static final List<ContentModel> _contentItemsCache = [

        // News
        ContentModel(
          id: 'c1',
          title: 'Attack on Titan: The Final Chapters — A Legacy Defined',
          description:
              'The manga has ended, the anime is complete. We break down the final arc and its divisive ending.',
          body: _longBodyText('Attack on Titan\'s final chapter closed one of the most acclaimed and debated arcs in anime history. Hajime Isayama\'s vision — starting with a boy who witnessed his mother devoured by a Titan — evolved into a complex political thriller exploring cycles of war, the nature of freedom, and the cost of peace.\n\nThe Rumbling. Eren Yeager\'s genocide. The Survey Corps fighting against their former comrade. Every thread woven across 139 chapters converged into a conclusion that polarized fans worldwide.\n\nSome hailed it as a masterpiece of subverted expectations. Others mourned the perceived abandonment of their beloved characters. Both camps agree: nothing in anime has hit quite the same way.\n\nIsayama himself acknowledged the imperfect nature of the ending in multiple interviews, but stood by its thematic core — that the cycle of hatred is perpetuated by both sides, and true peace comes only through impossible choices.\n\nThe legacy of Attack on Titan is now sealed. It changed what anime could be.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Attack_on_Titan.jpg/800px-Attack_on_Titan.jpg',
          contentType: ContentType.news,
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          tags: ['finale', 'anime', 'manga', 'review'],
          author: 'Fandom Verse Editorial',
          isFeatured: true,
          isPublished: true,
          isOfflineAvailable: true,
          readTimeMinutes: 8,
          viewCount: 124_500,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c2',
          title: 'BTS PURPLE COMEBACK — Everything We Know',
          description:
              'ARMY, the wait is over. Here\'s the complete breakdown of the upcoming comeback, teaser analysis, and album predictions.',
          body: _longBodyText('The BTS PURPLE COMEBACK announcement sent social media into a frenzy within minutes. Trending in 47 countries simultaneously, the teaser video alone accumulated 50 million views in 24 hours.\n\nWhat we know so far:\n\nThe concept images released suggest a dramatic shift from their previous soft INU era — darker tones, sharp lighting, and an aesthetic that recalls their Love Yourself era but elevated into something more cinematic.\n\nRM\'s latest Instagram posts have been obsessively analyzed by ARMY. The recurring purple motif, the architectural backdrops, the fragmented lyric snippets — all pointing toward a deeply personal album.\n\nThe production team reportedly includes collaborations with international producers known for genre-blending sound design. Expect the unexpected.\n\nFan theories range from a concept album about the universe expansion storyline to a completely introspective record about each member\'s individual artistry.\n\nOne thing is certain: this will break records.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/BTS_Arirang_World_Tour_in_Paris_%2817_July_2026%29_-_finale.jpg/960px-BTS_Arirang_World_Tour_in_Paris_%2817_July_2026%29_-_finale.jpg',
          contentType: ContentType.news,
          fandomId: 'f2',
          fandomName: 'BTS Universe',
          tags: ['comeback', 'kpop', 'army', 'album', 'teaser'],
          author: 'ARMY Correspondent',
          isFeatured: true,
          isPublished: true,
          isOfflineAvailable: true,
          readTimeMinutes: 6,
          viewCount: 289_000,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c3',
          title: 'The Water Hashira: Giyu Tomioka\'s Hidden Depth',
          description:
              'He rarely speaks, rarely emotes — but Giyu Tomioka is one of the most emotionally complex characters in Demon Slayer.',
          body: _longBodyText('At first glance, Giyu Tomioka presents as the archetype of the cold, stoic warrior. The Water Hashira barely speaks. He observes. He judges with his eyes, not his words. But Koyoharu Gotouge has embedded within this silent figure one of the manga\'s most profound character studies.\n\nGiyu\'s core wound: survivor\'s guilt compounded by isolation. His best friend Sabito died protecting him during the Final Selection — every student passed the selection because of Sabito\'s sacrifice. Giyu alone survived by accident.\n\nThis guilt shaped everything. His signature technique, "Dead Calm," is not merely a combat skill — it is the emotional state Giyu has trained himself to maintain permanently. He does not allow himself to feel because feeling reminds him that he survived when Sabito did not.\n\nHis relationship with Tanjiro breaks this pattern. Tanjiro\'s relentless empathy — even toward demons — forces Giyu to confront emotions he\'s suppressed for years.\n\nThe "Giyu is not Pillars\'s drinking friend" meme among Demon Slayer fans speaks to this isolation. He literally cannot be a friend. Not because he is unkind — but because he does not believe he deserves friendship.\n\nThis is what makes his development in the final arc so earned.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Cosplay_de_Kokushibo_Demon_slayer.jpg/454px-Cosplay_de_Kokushibo_Demon_slayer.jpg',
          contentType: ContentType.character,
          fandomId: 'f4',
          fandomName: 'Demon Slayer',
          tags: ['character', 'hashira', 'analysis', 'giyu', 'water'],
          author: 'Lore Analyst',
          isFeatured: false,
          isPublished: true,
          isOfflineAvailable: true,
          readTimeMinutes: 10,
          viewCount: 87_200,
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c4',
          title: 'Night City\'s Architecture: How CD Projekt Red Built a World',
          description:
              'A deep dive into the visual design language of Night City — influenced by Los Angeles, Hong Kong, and Tokyo.',
          body: _longBodyText('Night City did not emerge fully formed from a concept document. It was built over a decade of research, iteration, and disagreement among hundreds of artists, writers, and architects at CD Projekt Red.\n\nThe core visual DNA: Los Angeles sprawl + Hong Kong verticality + Tokyo neon density, filtered through a 2077 lens that asks "what if every dystopian prediction came true simultaneously?"\n\nThe six districts serve narrative functions as much as geographic ones:\n\nWatson — decay and immigrant hustle, where V begins their story.\nWestbrook — Japantown glamour over corporate rot.\nCity Center — megacorp power, clean surfaces hiding control.\nPacifica — abandoned dreams, the cost of corporate neglect.\nSanto Domingo — industrial grit and working-class survival.\nHeywood — gang territory shaped by history and pride.\n\nThe architectural team studied brutalism, cyberpunk illustrations from the 1980s source material, and contemporary megacity development patterns. Every building tells a story about who built it, who owns it, and who lives beneath it.\n\nNight City is, ultimately, a city designed to feel beautiful and terrible at the same time.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/PGA_2019_Cyberpunk_2077.jpg/960px-PGA_2019_Cyberpunk_2077.jpg',
          contentType: ContentType.lore,
          fandomId: 'f3',
          fandomName: 'Cyberpunk Universe',
          tags: ['worldbuilding', 'architecture', 'nightcity', 'lore'],
          author: 'World Lore Desk',
          isFeatured: true,
          isPublished: true,
          isOfflineAvailable: false,
          readTimeMinutes: 12,
          viewCount: 45_600,
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c5',
          title: 'Fandom Verse Podcast: Anime Season Preview',
          description:
              'Your hosts break down the upcoming anime season — what to watch, what to skip, and what might surprise you.',
          body: 'This week on the Fandom Verse podcast, hosts Mira and Kenji break down the upcoming season lineup.\n\nTopics covered:\n- The big three returning shows\n- Sleeper picks from lesser-known studios\n- Hot takes on continuation vs. original series\n- Listener questions answered\n\nRuntime: 58 minutes',
          imageUrl:
              'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=800&q=80',
          contentType: ContentType.podcast,
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          tags: ['podcast', 'anime', 'season', 'preview'],
          author: 'Fandom Verse Podcast',
          isFeatured: false,
          isPublished: true,
          isOfflineAvailable: true,
          readTimeMinutes: 58,
          viewCount: 32_100,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c6',
          title: 'BLACKPINK: The Documentary Behind the Scenes',
          description:
              'Exclusive behind-the-scenes footage and interview insights from the BLACKPINK documentary shoot.',
          body: _longBodyText('The cameras rolled for eighteen months. Four members. Thousands of miles of touring. And a level of access that even dedicated BLINKS hadn\'t seen before.\n\nThe BLACKPINK documentary offered a rare window into what it costs to be at the apex of global pop stardom. The exhaustion in their eyes after a sold-out stadium. The warmth between the four during downtime. The professional masks they slip on the moment they step toward any camera that isn\'t theirs.\n\nJisoo\'s art practice. Jennie\'s solo creative process. Rosé\'s guitar sessions in hotel rooms. Lisa\'s choreography notes filled with thousands of sketches.\n\nThese are not manufactured images from a press team. This is what four women at the center of cultural history actually look like when the concept machines slow down.\n\nBehind the scenes of the documentary reveals its own behind-the-scenes: the disagreements between the production crew and YG about which material could air. The conversations that were filmed but will never be seen. The moments that were kept private by mutual agreement.\n\nWhat we did see was already more honest than most artist documentaries allow.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Blackpink.jpg/960px-Blackpink.jpg',
          contentType: ContentType.behindScenes,
          fandomId: 'f6',
          fandomName: 'BLACKPINK',
          tags: ['documentary', 'blackpink', 'blink', 'behind-scenes'],
          author: 'FV Film Desk',
          isFeatured: false,
          isPublished: true,
          isOfflineAvailable: false,
          readTimeMinutes: 9,
          viewCount: 198_700,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c7',
          title: 'One Piece Devil Fruit Origins: What We Know After 1000+ Chapters',
          description:
              'The most comprehensive breakdown of Devil Fruit lore — from the Void Century to the mystery of awakening.',
          body: _longBodyText('After more than 1000 chapters, Devil Fruits remain one of the most fascinating — and deliberately mysterious — elements of the One Piece world.\n\nOda has been strategic about revelation. Just when fans believe they understand the rules, a new wrinkle emerges.\n\nWhat we know:\n\nDevil Fruits imbue extraordinary powers at the cost of swimming ability.\n\nThere are three types: Paramecia (body modification), Zoan (animal transformation), and Logia (element control).\n\nAwakenening allows the power to extend beyond the user\'s body into the surrounding environment.\n\nMythical Zoans are rarer than Logias and may have higher overall potential.\n\nThe Gomu Gomu no Mi — what Luffy ate — was not what it appeared. This was the Nika Nika no Mi, the Mythical Zoan fruit of the Sun God, actively hidden by the World Government for centuries. This single revelation recontextualized Luffy\'s entire journey.\n\nWhat we don\'t know:\n\nThe true origin of Devil Fruits. Are they created? Do they evolve? Do they reincarnate? Oda has hinted at answers that remain just out of reach.\n\nThis deliberate mystery is part of the genius of the series.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/One_Piece_%288413847339%29.jpg/960px-One_Piece_%288413847339%29.jpg',
          contentType: ContentType.lore,
          fandomId: 'f7',
          fandomName: 'One Piece',
          tags: ['lore', 'devil-fruit', 'analysis', 'one-piece'],
          author: 'Grand Line Analyst',
          isFeatured: true,
          isPublished: true,
          isOfflineAvailable: false,
          readTimeMinutes: 14,
          viewCount: 201_300,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c8',
          title: 'MCU Phase 6: What the Multiverse Means for the Next Avengers',
          description:
              'With the multiverse fully established, what does Phase 6 hold? We break down every confirmed and rumored project.',
          body: _longBodyText('The Multiverse Saga is more ambitious than the Infinity Saga in scope, if not yet in emotional resonance. Phase 6 arrives at the intersection of expectation and reinvention.\n\nConfirmed projects suggest a universe being reconfigured around new pillars. The old guard of the Infinity Saga has largely stepped aside. What fills their place?\n\nNew heroes bearing legacy mantles. Variants of beloved characters. Completely original narratives set against the backdrop of a fractured multiverse.\n\nThe biggest unresolved question: who is the audience for the next Avengers-level event? The casual viewer who only watches the movies? The dedicated fan tracking every Disney+ series for continuity threads?\n\nPhase 6 appears to be navigating this tension deliberately. Some projects are standalone entry points. Others reward the obsessive viewer with deep lore payoff.\n\nOne certainty: the next Avengers-level crossover will define whether the MCU\'s second chapter matches the cultural impact of the first.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Marvel_characters.jpg/960px-Marvel_characters.jpg',
          contentType: ContentType.news,
          fandomId: 'f5',
          fandomName: 'Marvel Cinematic',
          tags: ['mcu', 'avengers', 'multiverse', 'phase6'],
          author: 'MCU Analyst',
          isFeatured: false,
          isPublished: true,
          isOfflineAvailable: false,
          readTimeMinutes: 7,
          viewCount: 315_200,
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
          updatedAt: DateTime.now(),
        ),
        // Trivia
        ContentModel(
          id: 'c9',
          title: 'Hidden Details in AoT You Missed on First Watch',
          description:
              'Episode 1, Season 1 contains a frame that perfectly foreshadows the finale. And that\'s just the beginning.',
          body: _longBodyText('Hajime Isayama planted dozens of narrative seeds in the earliest chapters of Attack on Titan that only reveal their meaning after the final chapter.\n\nThe most famous: the boy in the final chapter is Eren himself, returned in some cyclical sense. The closing image deliberately mirrors the opening.\n\nLess discussed:\n\nThe hands reaching through walls in the early episodes — not atmospheric horror, but a visual metaphor for Titans as tools of a political system designed to contain people.\n\nArmin\'s book about the outside world in Episode 1 features illustrations that would only be fully explained in Season 4.\n\nEren\'s eyes change subtly throughout the series in moments that, in retrospect, may indicate moments of \"path\" awareness — contact with his future or past self.\n\nThe most chilling detail: in Episode 1, Carla Yeager says something to young Eren that, knowing his fate, becomes one of the darkest pieces of foreshadowing in the entire medium.\n\nIsayama planned this ending from the beginning. The breadcrumb trail is everywhere.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Attack_on_Titan.jpg/800px-Attack_on_Titan.jpg',
          contentType: ContentType.trivia,
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          tags: ['trivia', 'hidden', 'foreshadowing', 'details'],
          author: 'Detail Hunter',
          isFeatured: false,
          isPublished: true,
          isOfflineAvailable: true,
          readTimeMinutes: 6,
          viewCount: 167_400,
          createdAt: DateTime.now().subtract(const Duration(days: 18)),
          updatedAt: DateTime.now(),
        ),
        ContentModel(
          id: 'c10',
          title: 'BLACKPINK Choreography Breakdown: "Pink Venom"',
          description:
              'Frame by frame analysis of the Pink Venom choreography and the storytelling embedded in every movement.',
          body: _longBodyText('Pink Venom is, on the surface, a power statement. Four women asserting dominance through precision, attitude, and controlled chaos.\n\nBut the choreography tells a more layered story.\n\nThe opening formation — Lisa at center, the others fanning outward — establishes hierarchy then immediately subverts it. By the second verse, the formation logic has inverted. This mirrors the lyrics\' themes of identity and power exchange.\n\nJennie\'s rap section features deliberate stillness. While the backing dancers execute complex footwork, Jennie barely moves — making her the gravitational center of the frame. Motion emphasizes stillness. Stillness commands attention.\n\nThe "Pink Venom" hook features the group in synchrony for the first time in the piece — unity as release after individual assertion.\n\nLisa\'s rap breakdown is choreographically the most technically demanding section. The transitions between hip-hop influences, traditional Thai movement references, and contemporary pop structure are seamless.\n\nRosé\'s sections contain the most emotional variation — subtle expressiveness within precise technique.\n\nThis is choreography designed not just to be performed, but to be analyzed.'),
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Blackpink.jpg/960px-Blackpink.jpg',
          contentType: ContentType.editorial,
          fandomId: 'f6',
          fandomName: 'BLACKPINK',
          tags: ['choreography', 'analysis', 'blackpink', 'dance'],
          author: 'Dance Analyst',
          isFeatured: false,
          isPublished: true,
          isOfflineAvailable: false,
          readTimeMinutes: 8,
          viewCount: 234_800,
          createdAt: DateTime.now().subtract(const Duration(days: 22)),
          updatedAt: DateTime.now(),
        ),
      ];
  static List<ContentModel> get contentItems => _contentItemsCache;


  // ──────────────────────────────────────────────────────────
  // EVENTS
  // ──────────────────────────────────────────────────────────
  static final List<EventModel> _eventsCache = [

        EventModel(
          id: 'e1',
          title: 'AnimeCon Asia 2026',
          description:
              'Southeast Asia\'s largest anime convention returns with guest cosplayers, voice actors, exclusive merch, and live screenings.',
          imageUrl:
              'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80',
          city: 'Bangkok',
          venue: 'IMPACT Arena',
          address: 'Muang Thong Thani, Bangkok, Thailand',
          eventDate: DateTime.now().add(const Duration(days: 45)),
          eventEndDate: DateTime.now().add(const Duration(days: 47)),
          category: 'Convention',
          ticketLink: 'https://animeconasia.example.com/tickets',
          latitude: 13.9271,
          longitude: 100.5631,
          isFeatured: true,
          status: 'upcoming',
          attendeeCount: 85_000,
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        ),
        EventModel(
          id: 'e2',
          title: 'BTS PURPLE COMEBACK WATCH PARTY — KL',
          description:
              'Watch the live comeback performance together with fellow ARMY at the official watch party in Kuala Lumpur.',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/BTS_Arirang_World_Tour_in_Paris_%2817_July_2026%29_-_finale.jpg/960px-BTS_Arirang_World_Tour_in_Paris_%2817_July_2026%29_-_finale.jpg',
          city: 'Kuala Lumpur',
          venue: 'Stadium Axiata Arena',
          address: 'Bukit Jalil, Kuala Lumpur, Malaysia',
          eventDate: DateTime.now().add(const Duration(days: 12)),
          category: 'Concert',
          ticketLink: 'https://bts-kl.example.com',
          latitude: 3.0585,
          longitude: 101.6945,
          isFeatured: true,
          status: 'upcoming',
          attendeeCount: 12_000,
          fandomId: 'f2',
          fandomName: 'BTS Universe',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now(),
        ),
        EventModel(
          id: 'e3',
          title: 'Cosplay Championship — Night City Edition',
          description:
              'Cyberpunk-themed cosplay championship. Categories include Corpo, Street Kid, Nomad, and Full Creative.',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/PGA_2019_Cyberpunk_2077.jpg/960px-PGA_2019_Cyberpunk_2077.jpg',
          city: 'Singapore',
          venue: 'Marina Bay Sands Convention Centre',
          address: '10 Bayfront Ave, Singapore 018956',
          eventDate: DateTime.now().add(const Duration(days: 30)),
          category: 'Cosplay',
          ticketLink: 'https://cosplaychampsg.example.com',
          latitude: 1.2834,
          longitude: 103.8607,
          isFeatured: false,
          status: 'upcoming',
          attendeeCount: 5_000,
          fandomId: 'f3',
          fandomName: 'Cyberpunk Universe',
          createdAt: DateTime.now().subtract(const Duration(days: 40)),
          updatedAt: DateTime.now(),
        ),
        EventModel(
          id: 'e4',
          title: 'Demon Slayer: Kimetsu Stage Play',
          description:
              'The highly anticipated stage adaptation of Demon Slayer — featuring original choreography, live music, and stunning visual effects.',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Cosplay_de_Kokushibo_Demon_slayer.jpg/454px-Cosplay_de_Kokushibo_Demon_slayer.jpg',
          city: 'Ho Chi Minh City',
          venue: 'Saigon Opera House',
          address: '7 Lam Son Square, District 1, Ho Chi Minh City',
          eventDate: DateTime.now().add(const Duration(days: 60)),
          category: 'Screening',
          ticketLink: 'https://dsstageplay.example.com',
          latitude: 10.7763,
          longitude: 106.7034,
          isFeatured: true,
          status: 'upcoming',
          attendeeCount: 2_000,
          fandomId: 'f4',
          fandomName: 'Demon Slayer',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
        EventModel(
          id: 'e5',
          title: 'One Piece Manga Pop-Up Exhibition',
          description:
              'Original manga pages, character statues, interactive exhibits, and limited merchandise at this traveling One Piece exhibition.',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/One_Piece_%288413847339%29.jpg/960px-One_Piece_%288413847339%29.jpg',
          city: 'Manila',
          venue: 'SM Mall of Asia Arena',
          address: 'Seaside Blvd, Pasay, Metro Manila',
          eventDate: DateTime.now().add(const Duration(days: 20)),
          eventEndDate: DateTime.now().add(const Duration(days: 35)),
          category: 'Exhibition',
          ticketLink: 'https://oppopup.example.com',
          latitude: 14.5347,
          longitude: 120.9822,
          isFeatured: false,
          status: 'upcoming',
          attendeeCount: 40_000,
          fandomId: 'f7',
          fandomName: 'One Piece',
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now(),
        ),
        EventModel(
          id: 'e6',
          title: 'BLACKPINK BLINK FAN MEETUP — Hanoi',
          description:
              'Fan-organized meetup for BLINKS in Hanoi. Group streaming, merch swap, photo challenges, and more.',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Blackpink.jpg/960px-Blackpink.jpg',
          city: 'Hanoi',
          venue: 'Lotte Center Hanoi',
          address: '54 Lieu Giai, Ba Dinh, Hanoi',
          eventDate: DateTime.now().add(const Duration(days: 8)),
          category: 'Meetup',
          latitude: 21.0278,
          longitude: 105.8342,
          isFeatured: false,
          status: 'upcoming',
          fandomId: 'f6',
          fandomName: 'BLACKPINK',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now(),
        ),
      ];
  static List<EventModel> get events => _eventsCache;


  // ──────────────────────────────────────────────────────────
  // PRODUCTS
  // ──────────────────────────────────────────────────────────
  static final List<ProductModel> _productsCache = [

        ProductModel(
          id: 'p1',
          name: 'Survey Corps Cloak — Premium Edition',
          description:
              'Full-length wearable Survey Corps cloak with embroidered Wings of Freedom crest. Premium quality canvas fabric, officially inspired.',
          price: 89.99,
          imageUrl:
              'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=400&q=80',
          categoryId: 'cat1',
          categoryName: 'Apparel',
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          stock: 45,
          isFeatured: true,
          discountPercent: 15,
          tags: ['apparel', 'cloak', 'survey-corps', 'cosplay'],
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'p2',
          name: 'BTS PURPLE ERA Limited Photocard Set',
          description:
              'Exclusive set of 7 holographic photocards — one per member. Limited to 10,000 sets worldwide. Numbered and certificate of authenticity included.',
          price: 34.99,
          imageUrl:
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&q=80',
          categoryId: 'cat2',
          categoryName: 'Collectibles',
          fandomId: 'f2',
          fandomName: 'BTS Universe',
          stock: 2_300,
          isFeatured: true,
          tags: ['collectible', 'photocard', 'bts', 'limited'],
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'p3',
          name: 'Night City Street Map — Giclee Print',
          description:
              'High-resolution giclee print of the official Night City district map. Archival ink on heavyweight fine art paper. Available in 18x24 and 24x36.',
          price: 45.00,
          imageUrl:
              'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80',
          categoryId: 'cat3',
          categoryName: 'Accessories',
          fandomId: 'f3',
          fandomName: 'Cyberpunk Universe',
          stock: 150,
          isFeatured: false,
          tags: ['art', 'print', 'nightcity', 'map', 'decor'],
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'p4',
          name: 'Tanjiro\'s Hanafuda Earrings — 925 Silver',
          description:
              'Handcrafted 925 sterling silver replica of Tanjiro\'s iconic hanafuda earrings. Each pair individually inspected. Comes in collector\'s box.',
          price: 28.99,
          imageUrl:
              'https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=400&q=80',
          categoryId: 'cat2',
          categoryName: 'Collectibles',
          fandomId: 'f4',
          fandomName: 'Demon Slayer',
          stock: 380,
          isFeatured: true,
          discountPercent: 10,
          tags: ['jewelry', 'earrings', 'tanjiro', 'silver', 'cosplay'],
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'p5',
          name: 'BLACKPINK Born Pink Tour Hoodie',
          description:
              'Official tour-inspired design. Heavy-weight 100% organic cotton. Ribbed cuffs and waistband. Available in black and cream.',
          price: 65.00,
          imageUrl:
              'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&q=80',
          categoryId: 'cat1',
          categoryName: 'Apparel',
          fandomId: 'f6',
          fandomName: 'BLACKPINK',
          stock: 0,
          isFeatured: false,
          tags: ['apparel', 'hoodie', 'blackpink', 'tour'],
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'p6',
          name: 'Devil Fruit Mystery Box',
          description:
              'Which Devil Fruit will you get? Each box contains a random Devil Fruit figure from the One Piece universe. Rare variants exist.',
          price: 19.99,
          imageUrl:
              'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=400&q=80',
          categoryId: 'cat2',
          categoryName: 'Collectibles',
          fandomId: 'f7',
          fandomName: 'One Piece',
          stock: 2_000,
          isFeatured: true,
          tags: ['mystery', 'collectible', 'one-piece', 'figure'],
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'p7',
          name: 'Iron Man MK-85 Gauntlet Replica',
          description:
              'Wearable Infinity Gauntlet replica inspired by Tony Stark\'s MK-85. LED-lit Infinity Stones. Display stand included.',
          price: 149.99,
          imageUrl:
              'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=400&q=80',
          categoryId: 'cat2',
          categoryName: 'Collectibles',
          fandomId: 'f5',
          fandomName: 'Marvel Cinematic',
          stock: 65,
          isFeatured: true,
          discountPercent: 20,
          tags: ['marvel', 'ironman', 'gauntlet', 'replica', 'led'],
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'p8',
          name: 'Fandom Verse Premium Enamel Pin Set',
          description:
              'Set of 6 exclusive Fandom Verse enamel pins — featuring iconic symbols from anime, K-pop, and gaming fandoms.',
          price: 22.00,
          imageUrl:
              'https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?w=400&q=80',
          categoryId: 'cat3',
          categoryName: 'Accessories',
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          stock: 500,
          isFeatured: false,
          tags: ['pin', 'enamel', 'accessories', 'set', 'fandom-verse'],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now(),
        ),
      ];
  static List<ProductModel> get products => _productsCache;


  // ──────────────────────────────────────────────────────────
  // CATEGORIES
  // ──────────────────────────────────────────────────────────
  static final List<dynamic> _categoriesCache = [

        {
          'id': 'cat1',
          'name': 'Apparel',
          'description': 'Clothing and wearable fandom merchandise',
          'iconName': 'checkroom',
          'type': 'product',
          'displayOrder': 1,
        },
        {
          'id': 'cat2',
          'name': 'Collectibles',
          'description': 'Limited edition figures, cards, and memorabilia',
          'iconName': 'star',
          'type': 'product',
          'displayOrder': 2,
        },
        {
          'id': 'cat3',
          'name': 'Accessories',
          'description': 'Bags, pins, jewelry, and lifestyle accessories',
          'iconName': 'diamond',
          'type': 'product',
          'displayOrder': 3,
        },
        {
          'id': 'cat4',
          'name': 'Digital',
          'description': 'Digital art, wallpapers, and digital collectibles',
          'iconName': 'tablet_android',
          'type': 'product',
          'displayOrder': 4,
        },
      ];
  static List<dynamic> get categories => _categoriesCache;


  // ──────────────────────────────────────────────────────────
  // BADGES
  // ──────────────────────────────────────────────────────────
  static final List<BadgeModel> _badgesCache = [

        BadgeModel(
          id: 'b1',
          name: 'Anime Devotee',
          description: 'Dedicated fan of the anime universe',
          iconEmoji: '⚔️',
          rarity: 'common',
          fandomCategory: 'Anime',
          createdAt: DateTime.now().subtract(const Duration(days: 200)),
        ),
        BadgeModel(
          id: 'b2',
          name: 'ARMY Forever',
          description: 'True BTS ARMY member',
          iconEmoji: '💜',
          rarity: 'common',
          fandomCategory: 'K-Pop',
          createdAt: DateTime.now().subtract(const Duration(days: 190)),
        ),
        BadgeModel(
          id: 'b3',
          name: 'Lore Master',
          description: 'Expert in fandom lore and hidden details',
          iconEmoji: '🔮',
          rarity: 'rare',
          fandomCategory: 'Anime',
          createdAt: DateTime.now().subtract(const Duration(days: 180)),
        ),
        BadgeModel(
          id: 'b4',
          name: 'Cosplay Legend',
          description: 'Recognized for exceptional cosplay quality',
          iconEmoji: '🎭',
          rarity: 'epic',
          fandomCategory: 'Cosplay',
          createdAt: DateTime.now().subtract(const Duration(days: 170)),
        ),
        BadgeModel(
          id: 'b5',
          name: 'BLINK Elite',
          description: 'Top-tier BLACKPINK fan identity',
          iconEmoji: '🌸',
          rarity: 'rare',
          fandomCategory: 'K-Pop',
          createdAt: DateTime.now().subtract(const Duration(days: 160)),
        ),
        BadgeModel(
          id: 'b6',
          name: 'Night Runner',
          description: 'Expert in the Cyberpunk universe',
          iconEmoji: '🌆',
          rarity: 'epic',
          fandomCategory: 'Gaming',
          createdAt: DateTime.now().subtract(const Duration(days: 150)),
        ),
        BadgeModel(
          id: 'b7',
          name: 'Titan Slayer',
          description: 'Mastered the Attack on Titan universe',
          iconEmoji: '🗡️',
          rarity: 'legendary',
          fandomCategory: 'Anime',
          createdAt: DateTime.now().subtract(const Duration(days: 140)),
        ),
        BadgeModel(
          id: 'b8',
          name: 'First Generation Fan',
          description: 'One of the first Fandom Verse members',
          iconEmoji: '⭐',
          rarity: 'legendary',
          fandomCategory: 'All',
          createdAt: DateTime.now().subtract(const Duration(days: 130)),
        ),
      ];
  static List<BadgeModel> get badges => _badgesCache;


  // ──────────────────────────────────────────────────────────
  // FAQ / AI HELPER DATA
  // ──────────────────────────────────────────────────────────
  static final List<FaqModel> _faqsCache = [

        FaqModel(
          id: 'faq1',
          question: 'What is Fandom Verse?',
          answer:
              'Fandom Verse is your ultimate fandom companion app — a premium platform where fans discover news, lore, events, merchandise, and connect with their favorite anime, K-pop, gaming, and entertainment communities.',
          category: 'General',
          tags: ['about', 'fandom-verse'],
          helpfulCount: 450,
          createdAt: DateTime.now().subtract(const Duration(days: 100)),
        ),
        FaqModel(
          id: 'faq2',
          question: 'How do I select my fandoms?',
          answer:
              'During onboarding, you\'ll be shown a fandom selection screen where you can choose the fandoms you\'re interested in. You can always update your selection from Profile → My Fandoms. Your home feed will be personalized based on your selections.',
          category: 'Account',
          tags: ['fandoms', 'personalization'],
          helpfulCount: 320,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
        ),
        FaqModel(
          id: 'faq3',
          question: 'What are Fan Badges?',
          answer:
              'Fan Badges are collectible identity markers that represent your dedication and expertise in different fandoms. Badges come in four rarities: Common, Rare, Epic, and Legendary. Select your badges from Profile → Fan Identity to display them on your profile.',
          category: 'Badges',
          tags: ['badges', 'identity', 'profile'],
          helpfulCount: 280,
          createdAt: DateTime.now().subtract(const Duration(days: 80)),
        ),
        FaqModel(
          id: 'faq4',
          question: 'How does the Store work?',
          answer:
              'Browse fandom merchandise in the Store tab. Add items to your cart and proceed to checkout for a simulated purchase experience. Your order history is saved in your profile. Note: this is a demo experience — no real transactions are processed.',
          category: 'Store',
          tags: ['store', 'cart', 'checkout'],
          helpfulCount: 190,
          createdAt: DateTime.now().subtract(const Duration(days: 70)),
        ),
        FaqModel(
          id: 'faq5',
          question: 'Can I save content for offline reading?',
          answer:
              'Yes! Tap the bookmark icon on any supported content to save it. Bookmarked content with offline support will be cached locally and available even without an internet connection. Access saved content from your Bookmarks tab or Profile → Saved Content.',
          category: 'Content',
          tags: ['offline', 'bookmarks', 'saved'],
          helpfulCount: 410,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
        ),
        FaqModel(
          id: 'faq6',
          question: 'What is the Deep Dive section?',
          answer:
              'Deep Dive is curated expert-level content for dedicated fans — hidden trivia, advanced lore analysis, behind-the-scenes breakdowns, and editorial deep dives into fandom history and theory. It\'s designed for fans who want to go beyond the surface.',
          category: 'Content',
          tags: ['deep-dive', 'lore', 'trivia'],
          helpfulCount: 230,
          createdAt: DateTime.now().subtract(const Duration(days: 50)),
        ),
        FaqModel(
          id: 'faq7',
          question: 'How do I find events near me?',
          answer:
              'Go to the Events tab and tap "Nearby Events" to find fandom events close to your location. You can also filter events by city, category, and date. Tap on any event for details and ticket information.',
          category: 'Events',
          tags: ['events', 'nearby', 'location'],
          helpfulCount: 175,
          createdAt: DateTime.now().subtract(const Duration(days: 40)),
        ),
        FaqModel(
          id: 'faq8',
          question: 'What is the Beginner Fan Hub?',
          answer:
              'The Beginner Fan Hub is designed for people new to a fandom. It contains introductory content, character guides, glossaries, and starter lore — everything you need to get up to speed without feeling overwhelmed. Access it from the Explore tab.',
          category: 'Content',
          tags: ['beginner', 'hub', 'starter'],
          helpfulCount: 290,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ];
  static List<FaqModel> get faqs => _faqsCache;


  // ──────────────────────────────────────────────────────────
  // GLOSSARY
  // ──────────────────────────────────────────────────────────
  static final List<GlossaryModel> _glossaryTermsCache = [

        GlossaryModel(
          id: 'g1',
          term: 'Hashira',
          definition:
              'The nine Pillars of the Demon Slayer Corps — the highest-ranking demon slayers. Each Hashira masters a unique Breathing Style and possesses extraordinary combat ability.',
          example:
              'Giyu Tomioka is the Water Hashira; Rengoku Kyojuro was the Flame Hashira.',
          fandomId: 'f4',
          fandomName: 'Demon Slayer',
          relatedTerms: ['Breathing Style', 'Demon Slayer Corps', 'Kasugai Crow'],
          difficulty: 'beginner',
          createdAt: DateTime.now().subtract(const Duration(days: 80)),
        ),
        GlossaryModel(
          id: 'g2',
          term: 'Breathing Style',
          definition:
              'A combat technique in Demon Slayer that allows users to dramatically enhance their physical abilities by controlling their breathing in specific patterns.',
          example:
              'Tanjiro uses Water Breathing and later Hinokami Kagura (Sun Breathing).',
          fandomId: 'f4',
          fandomName: 'Demon Slayer',
          relatedTerms: ['Hashira', 'Total Concentration Breathing', 'Sun Breathing'],
          difficulty: 'beginner',
          createdAt: DateTime.now().subtract(const Duration(days: 79)),
        ),
        GlossaryModel(
          id: 'g3',
          term: 'Devil Fruit',
          definition:
              'Mysterious fruits in the One Piece world that grant supernatural powers to those who eat them, at the cost of the ability to swim.',
          example:
              'Luffy ate the Gomu Gomu no Mi (actually the Hito Hito no Mi, Model: Nika), making his body rubber-like.',
          fandomId: 'f7',
          fandomName: 'One Piece',
          relatedTerms: ['Haki', 'Awakening', 'Paramecia', 'Zoan', 'Logia'],
          difficulty: 'beginner',
          createdAt: DateTime.now().subtract(const Duration(days: 75)),
        ),
        GlossaryModel(
          id: 'g4',
          term: 'Haki',
          definition:
              'A mysterious power in One Piece that allows users to utilize their own spiritual energy for various uses. There are three types: Observation, Armament, and Conqueror\'s Haki.',
          example:
              'Shanks knocked out half of Whitebeard\'s crew with a single surge of Conqueror\'s Haki.',
          fandomId: 'f7',
          fandomName: 'One Piece',
          relatedTerms: ['Conqueror\'s Haki', 'Observation Haki', 'Armament Haki'],
          difficulty: 'intermediate',
          createdAt: DateTime.now().subtract(const Duration(days: 74)),
        ),
        GlossaryModel(
          id: 'g5',
          term: 'Yeagerist',
          definition:
              'A faction in Attack on Titan who follow Eren Yeager\'s ideology and support the Rumbling — the use of Wall Titans to annihilate all life outside Paradis.',
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          relatedTerms: ['Rumbling', 'Titans', 'Paradis'],
          difficulty: 'intermediate',
          createdAt: DateTime.now().subtract(const Duration(days: 70)),
        ),
        GlossaryModel(
          id: 'g6',
          term: 'ARMY',
          definition:
              'The official BTS fan community name. ARMY stands for "Adorable Representative M.C. for Youth." The name symbolizes the bond between BTS and their fans — an army and bulletproof vest protecting each other.',
          fandomId: 'f2',
          fandomName: 'BTS Universe',
          relatedTerms: ['HYBE', 'Bangtan', 'Purple'],
          difficulty: 'beginner',
          createdAt: DateTime.now().subtract(const Duration(days: 65)),
        ),
        GlossaryModel(
          id: 'g7',
          term: 'Netrunner',
          definition:
              'In the Cyberpunk universe, a Netrunner is a hacker who can interface directly with the NET and cyberspace. They use specialized cyberware to navigate and attack digital systems.',
          example:
              'Lucy from Cyberpunk: Edge Runners is a skilled Netrunner.',
          fandomId: 'f3',
          fandomName: 'Cyberpunk Universe',
          relatedTerms: ['ICE', 'Quickhack', 'Cyberware', 'NET'],
          difficulty: 'intermediate',
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
        ),
        GlossaryModel(
          id: 'g8',
          term: 'Blink',
          definition:
              'The official BLACKPINK fan community name. "BLINK" is a combination of "BLACK" and "PINK," representing the two colors in BLACKPINK\'s brand identity.',
          fandomId: 'f6',
          fandomName: 'BLACKPINK',
          relatedTerms: ['YG Entertainment', 'Comeback', 'World Tour'],
          difficulty: 'beginner',
          createdAt: DateTime.now().subtract(const Duration(days: 55)),
        ),
      ];
  static List<GlossaryModel> get glossaryTerms => _glossaryTermsCache;


  // ──────────────────────────────────────────────────────────
  // HELPER
  // ──────────────────────────────────────────────────────────
  static String _longBodyText(String text) => text;

  static List<FandomModel> getFandomsByCategory(String category) =>
      fandoms.where((f) => f.category == category).toList();

  static List<FandomModel> get featuredFandoms =>
      fandoms.where((f) => f.isFeatured).toList();

  static List<ContentModel> getContentByFandom(String fandomId) =>
      contentItems.where((c) => c.fandomId == fandomId).toList();

  static List<ContentModel> getContentByType(ContentType type) =>
      contentItems.where((c) => c.contentType == type).toList();

  static List<ContentModel> get featuredContent =>
      contentItems.where((c) => c.isFeatured && c.isPublished).toList();

  static List<ContentModel> get offlineContent =>
      contentItems.where((c) => c.isOfflineAvailable).toList();

  static List<EventModel> get upcomingEvents =>
      events.where((e) => e.isUpcoming).toList()
        ..sort((a, b) => a.eventDate.compareTo(b.eventDate));

  static List<ProductModel> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  static List<ProductModel> getProductsByFandom(String fandomId) =>
      products.where((p) => p.fandomId == fandomId).toList();

  static List<GlossaryModel> searchGlossary(String query) {
    final q = query.toLowerCase();
    return glossaryTerms
        .where((g) =>
            g.term.toLowerCase().contains(q) ||
            g.definition.toLowerCase().contains(q))
        .toList();
  }

  static List<FaqModel> searchFaq(String query) {
    final q = query.toLowerCase();
    return faqs
        .where((f) =>
            f.question.toLowerCase().contains(q) ||
            f.answer.toLowerCase().contains(q))
        .toList();
  }

  static List<String> get fandomCategories =>
      ['Anime', 'K-Pop', 'Gaming', 'Movies', 'TV', 'Comics', 'Sci-Fi'];

  static final List<CharacterModel> _charactersCache = [

        CharacterModel(
          id: 'c1',
          name: 'Eren Yeager',
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          description: 'A former member of the Survey Corps who seeks freedom.',
          imageUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=400&q=80',
          traits: ['Determined', 'Reckless', 'Titan Shifter'],
          role: 'protagonist',
          createdAt: DateTime.now(),
        ),
        CharacterModel(
          id: 'c2',
          name: 'Tanjiro Kamado',
          fandomId: 'f4',
          fandomName: 'Demon Slayer',
          description: 'A kind-hearted boy who becomes a Demon Slayer to cure his sister.',
          imageUrl: 'https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=400&q=80',
          traits: ['Kind', 'Strong Sense of Smell', 'Swordsman'],
          role: 'protagonist',
          createdAt: DateTime.now(),
        ),
        CharacterModel(
          id: 'c3',
          name: 'Luffy',
          fandomId: 'f1',
          fandomName: 'One Piece', // Using f1 for brevity
          description: 'The captain of the Straw Hat Pirates.',
          imageUrl: 'https://images.unsplash.com/photo-1605806616949-1e87b487cb2a?w=400&q=80',
          traits: ['Ambitious', 'Rubber Body', 'Pirate'],
          role: 'protagonist',
          createdAt: DateTime.now(),
        ),
        CharacterModel(
          id: 'c4',
          name: 'V',
          fandomId: 'f2',
          fandomName: 'BTS Universe',
          description: 'A vocalist and visual in BTS.',
          imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&q=80',
          traits: ['Vocalist', 'Visual', 'Actor'],
          role: 'supporting',
          createdAt: DateTime.now(),
        ),
        CharacterModel(
          id: 'c5',
          name: 'Lisa',
          fandomId: 'f6',
          fandomName: 'BLACKPINK',
          description: 'Main dancer and lead rapper of BLACKPINK.',
          imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&q=80',
          traits: ['Dancer', 'Rapper', 'Fashion Icon'],
          role: 'supporting',
          createdAt: DateTime.now(),
        ),
        CharacterModel(
          id: 'c6',
          name: 'Johnny Silverhand',
          fandomId: 'f3',
          fandomName: 'Cyberpunk Universe',
          description: 'A legendary rockerboy and frontman of Samurai.',
          imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80',
          traits: ['Rockerboy', 'Rebel', 'Construct'],
          role: 'supporting',
          createdAt: DateTime.now(),
        ),
      ];
  static List<CharacterModel> get characters => _charactersCache;

}
