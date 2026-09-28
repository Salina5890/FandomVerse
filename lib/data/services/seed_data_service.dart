import 'package:get/get.dart';
import '../models/fandom_model.dart';
import '../models/content_model.dart';
import '../models/event_model.dart';
import '../models/product_model.dart';
import '../models/misc_models.dart';
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
          'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=1200&q=80',
      tags: ['action', 'dark', 'war', 'titans', 'military'],
      isFeatured: true,
      memberCount: 2400000,
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
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1200&q=80',
      tags: ['k-pop', 'music', 'army', 'comeback', 'idol'],
      isFeatured: true,
      memberCount: 5100000,
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
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1200&q=80',
      tags: ['cyberpunk', 'rpg', 'sci-fi', 'neon', 'dystopian', 'gaming'],
      isFeatured: true,
      memberCount: 890000,
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
          'https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=1200&q=80',
      tags: ['anime', 'demons', 'samurai', 'hashira', 'tanjiro'],
      isFeatured: true,
      memberCount: 1800000,
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
          'https://images.unsplash.com/photo-1635863138275-d9b33299680b?w=1200&q=80',
      tags: ['marvel', 'avengers', 'mcu', 'superheroes', 'comics'],
      isFeatured: true,
      memberCount: 3200000,
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
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=1200&q=80',
      tags: ['k-pop', 'blackpink', 'blink', 'music', 'fashion'],
      isFeatured: false,
      memberCount: 4700000,
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
          'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1200&q=80',
      tags: ['anime', 'pirate', 'grandline', 'devil-fruit', 'luffy'],
      isFeatured: true,
      memberCount: 2900000,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
      updatedAt: DateTime.now(),
    ),
    FandomModel(
      id: 'f8',
      name: 'Halo & Sci-Fi Universe',
      description:
          'From the Covenant War to deep galactic exploration — explore the UNSC, Spartans, and high-tech cosmos.',
      category: 'Sci-Fi',
      coverImageUrl:
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&q=80',
      tags: ['halo', 'fps', 'spartan', 'sci-fi', 'space', 'gaming'],
      isFeatured: true,
      memberCount: 940000,
      createdAt: DateTime.now().subtract(const Duration(days: 130)),
      updatedAt: DateTime.now(),
    ),
  ];
  static List<FandomModel> get fandoms => _fandomsCache;


  // ──────────────────────────────────────────────────────────
  // CONTENT (NEWS, GALLERIES, VIDEOS, PODCASTS, LORE)
  // ──────────────────────────────────────────────────────────
  static final List<ContentModel> _contentItemsCache = [
    // ── NEWS ──
    ContentModel(
      id: 'c1',
      title: 'Attack on Titan: The Final Arc Legacy & Studio Retrospective',
      description:
          'How Hajime Isayama and MAPPA crafted a masterclass finale that forever reshaped dark fantasy anime.',
      body: _longBodyText('Attack on Titan\'s conclusion closed one of the most celebrated and complex sagas in modern storytelling. From Eren\'s pursuit of ultimate freedom to the tragic inevitability of the Rumbling, every narrative thread collided in a masterwork of emotional weight and animation craft.\n\nMAPPA\'s dedicated staff spent three years orchestrating the climactic confrontations. The visual design of the Founding Titan, the orchestral score by Hiroyuki Sawano and Kohta Yamamoto, and the raw vocal performances delivered an indelible cultural milestone.\n\nHere we explore the key creative choices, uncut storyboard sequences, and the lasting philosophy behind the battle between destiny and human free will.'),
      imageUrl:
          'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=1200&q=80',
      contentType: ContentType.news,
      fandomId: 'f1',
      fandomName: 'Attack on Titan',
      tags: ['News', 'Anime', 'Finale', 'Dark Fantasy', 'MAPPA'],
      author: 'Fandom Verse Editorial',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 8,
      viewCount: 145200,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'c2',
      title: 'Cyberpunk 2077 Orion: Next-Gen Engine & Lore Teasers',
      description:
          'CD Projekt Red reveals new concept art and narrative direction for the upcoming Night City sequel.',
      body: _longBodyText('The next chapter in the Cyberpunk universe, codenamed Project Orion, is officially entering full production. Powered by Unreal Engine 5 with proprietary photorealistic neural lighting, the sequel promises to expand beyond the borders of Night City into the Orbital Crystal Palace and the Badlands.\n\nNarrative leads confirm that player choices will carry heavier faction weight between Arasaka remnants, Militech black-ops, and rogue NetWatch subnets.\n\nExclusive concept documents hint at a completely revamped cyberware humanity system and aerial vehicle gameplay.'),
      imageUrl:
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1200&q=80',
      contentType: ContentType.news,
      fandomId: 'f3',
      fandomName: 'Cyberpunk Universe',
      tags: ['News', 'Gaming', 'Cyberpunk', 'Sci-Fi', 'RPG'],
      author: 'Night City Beat',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 6,
      viewCount: 189000,
      createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'c3',
      title: 'MCU Multiverse Wars: Phase 6 Lineup & Secret Wars Breakdown',
      description:
          'Everything confirmed for Avengers: Secret Wars, Battleworld incursions, and the cosmic hierarchy.',
      body: _longBodyText('Marvel Studios has officially unveiled the roadmap leading directly into Battleworld. With the multiverse expanding across divergent timelines, the cosmic stakes have never been higher.\n\nKey reveals include the return of classic iconic variants, cosmic entities including the Living Tribunal and Beyonders, and a clash of timelines that will culminate in a unified new MCU continuity.'),
      imageUrl:
          'https://images.unsplash.com/photo-1635863138275-d9b33299680b?w=1200&q=80',
      contentType: ContentType.news,
      fandomId: 'f5',
      fandomName: 'Marvel Cinematic',
      tags: ['News', 'Movies', 'Marvel', 'Superheroes', 'Sci-Fi'],
      author: 'Cosmic Marvel Desk',
      isFeatured: false,
      isPublished: true,
      isOfflineAvailable: false,
      readTimeMinutes: 7,
      viewCount: 231500,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'c4',
      title: 'BTS PURPLE WORLD TOUR — Global Stadium Dates Confirmed',
      description:
          'ARMY worldwide prepares for the biggest stadium tour in history featuring cutting-edge holographic stages.',
      body: _longBodyText('BIGHIT Music announced the global itinerary for the upcoming BTS PURPLE World Tour. Spanning 32 cities across 5 continents, the tour will introduce 360-degree floating holographic stage sets designed by top visual artists.\n\nPresale access begins next week with tiered benefits for certified FandomVerse ARMY badge holders.'),
      imageUrl:
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1200&q=80',
      contentType: ContentType.news,
      fandomId: 'f2',
      fandomName: 'BTS Universe',
      tags: ['News', 'K-Pop', 'Concert', 'BTS', 'ARMY'],
      author: 'Global Pop Desk',
      isFeatured: false,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 5,
      viewCount: 312000,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),

    // ── GALLERIES (HIGH-RES GAMING, SCI-FI, ANIME, FANTASY ART) ──
    ContentModel(
      id: 'g1',
      title: 'Neon Samurai — Night City Cyberpunk Concept Art',
      description: 'Ultra high-definition wallpaper series capturing cybernetic ronin beneath rainy neon skyscraper alleyways.',
      body: 'High-res 4K digital concept art set created with Blender and Octane renderer. Features heavy rain particle physics, raytraced neon luminescence, and customized cybernetic katana designs.',
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200&q=80',
        'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1200&q=80',
        'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=1200&q=80',
        'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1200&q=80',
      ],
      contentType: ContentType.gallery,
      fandomId: 'f3',
      fandomName: 'Cyberpunk Universe',
      tags: ['Gaming', 'Cyberpunk', 'Sci-Fi', 'Wallpaper', 'Concept Art'],
      author: 'Kaelen Vance (CyberArtist)',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 2,
      viewCount: 48200,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'g2',
      title: 'Deep Space Armada — Orbital Sci-Fi Battlefleet',
      description: 'Grand cosmic wallpapers showcasing hyperspace dreadnoughts and planetary defence rings.',
      body: 'Stunning cosmic illustrations depicting interstellar fleet formations, glowing ion thrusters, and binary star horizons.',
      imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&q=80',
        'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=1200&q=80',
        'https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?w=1200&q=80',
        'https://images.unsplash.com/photo-1518770660439-4636190af475?w=1200&q=80',
      ],
      contentType: ContentType.gallery,
      fandomId: 'f8',
      fandomName: 'Halo & Sci-Fi Universe',
      tags: ['Sci-Fi', 'Space', 'Gaming', 'Halo', 'Wallpaper'],
      author: 'NovaStudio CGI',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 3,
      viewCount: 62400,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'g3',
      title: 'Demon Slayer — Water Breathing & Flame Form Visuals',
      description: 'Dynamic battle stance illustrations and traditional Japanese ukiyo-e inspired anime art.',
      body: 'Artistic series inspired by the Hashira breathing techniques, featuring vivid swirling elemental dragons and gold-leaf calligraphy textures.',
      imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=1200&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=1200&q=80',
        'https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=1200&q=80',
        'https://images.unsplash.com/photo-1528164344705-475426879c0d?w=1200&q=80',
      ],
      contentType: ContentType.gallery,
      fandomId: 'f4',
      fandomName: 'Demon Slayer',
      tags: ['Anime', 'Demon Slayer', 'Samurai', 'Wallpaper', 'Art'],
      author: 'Yukihiro Designs',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 2,
      viewCount: 89300,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'g4',
      title: 'Avenger Multiverse — Quantum Armors & Cosmic Portals',
      description: 'Hyper-detailed digital character renders of high-tech heroes and multiversal rifts.',
      body: 'A master collection of superhero concepts combining nano-armor plating, glowing arc reactors, and kaleidoscopic dimensional fractals.',
      imageUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=1200&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=1200&q=80',
        'https://images.unsplash.com/photo-1635863138275-d9b33299680b?w=1200&q=80',
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=1200&q=80',
      ],
      contentType: ContentType.gallery,
      fandomId: 'f5',
      fandomName: 'Marvel Cinematic',
      tags: ['Superheroes', 'Marvel', 'Sci-Fi', 'Gaming', 'Wallpaper'],
      author: 'Marcus Cole 3D',
      isFeatured: false,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 2,
      viewCount: 41800,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'g5',
      title: 'Eldritch Realm — Dark Fantasy & Boss Arena Art',
      description: 'Atmospheric fantasy landscape art depicting towering gothic castles, glowing ruins, and dragon spires.',
      body: 'Moody concept landscapes celebrating the golden age of dark fantasy and soulslike aesthetic exploration.',
      imageUrl: 'https://images.unsplash.com/photo-1563089145-599997674d42?w=1200&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1563089145-599997674d42?w=1200&q=80',
        'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=1200&q=80',
        'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1200&q=80',
      ],
      contentType: ContentType.gallery,
      fandomId: 'f1',
      fandomName: 'Attack on Titan',
      tags: ['Fantasy', 'Gaming', 'Dark Fantasy', 'Wallpaper'],
      author: 'Astral Lore Labs',
      isFeatured: false,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 2,
      viewCount: 35600,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      updatedAt: DateTime.now(),
    ),

    // ── VIDEOS (TRAILERS, GAMEPLAY HIGHLIGHTS, ANIME CLIPS) ──
    ContentModel(
      id: 'v1',
      title: 'Cyberpunk 2077: Phantom Liberty — Cinematic Combat Breakdown',
      description: 'Official 4K 60FPS breakdown of Sandevistan melee mechanics, relic perks, and Dogtown secrets.',
      body: 'Watch this deep technical breakdown of high-speed melee builds and stealth takedowns in the dangerous combat zones of Dogtown.',
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1200&q=80',
      thumbnailUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
      mediaUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      durationSeconds: 495,
      contentType: ContentType.video,
      fandomId: 'f3',
      fandomName: 'Cyberpunk Universe',
      tags: ['Video', 'Gaming', 'Cyberpunk', 'Highlights', '4K'],
      author: 'Night City Cinema',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 8,
      viewCount: 94100,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'v2',
      title: 'Attack on Titan: The Final Battle of Heaven and Earth (OST Clip)',
      description: 'Relive the climactic clash with high-fidelity orchestral audio and jaw-dropping aerial animation.',
      body: 'An unforgettable 10-minute compilation highlighting the Scouts final charge with official remastered sound design.',
      imageUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=1200&q=80',
      thumbnailUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&q=80',
      mediaUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      durationSeconds: 612,
      contentType: ContentType.video,
      fandomId: 'f1',
      fandomName: 'Attack on Titan',
      tags: ['Video', 'Anime', 'OST', 'Action', 'HD'],
      author: 'AnimeVerse Highlights',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 10,
      viewCount: 156400,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'v3',
      title: 'Halo Infinite: Spartan Pro League Finals — Top 10 Plays',
      description: 'The most insane sniper headshots, flag captures, and grapple-hook maneuvers from the world championship.',
      body: 'Competitive esports highlight reel featuring the world finest FPS players executing flawless strategy under tournament pressure.',
      imageUrl: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=1200&q=80',
      thumbnailUrl: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=800&q=80',
      mediaUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      durationSeconds: 380,
      contentType: ContentType.video,
      fandomId: 'f8',
      fandomName: 'Halo & Sci-Fi Universe',
      tags: ['Video', 'Gaming', 'Esports', 'Halo', 'Highlights'],
      author: 'HCS Esports Desk',
      isFeatured: false,
      isPublished: true,
      isOfflineAvailable: false,
      readTimeMinutes: 6,
      viewCount: 78200,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),

    // ── PODCASTS (EPISODES, TALK SHOWS, SOUNDTRACK BREAKDOWNS) ──
    ContentModel(
      id: 'p1',
      title: 'FandomVerse Radio Ep. 42: Next-Gen Open World Gaming Lore',
      description: 'Hosts Jin & Sarah discuss world-building in Cyberpunk, Elden Ring, and what makes video game stories unforgettable.',
      body: 'In this episode:\n- Deconstructing lore through environmental storytelling\n- Sound design and emotional connection\n- Future of AI NPCs in open world RPGs\n- Fan questions and community shoutouts.\n\nTotal Runtime: 48 minutes',
      imageUrl: 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=1200&q=80',
      mediaUrl: 'https://example.com/audio/fandomverse_ep42.mp3',
      durationSeconds: 2880,
      contentType: ContentType.podcast,
      fandomId: 'f3',
      fandomName: 'Cyberpunk Universe',
      tags: ['Podcast', 'Gaming', 'Lore', 'Audio', 'Discussion'],
      author: 'FandomVerse Official Podcast',
      isFeatured: true,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 48,
      viewCount: 52100,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'p2',
      title: 'The Anime Lore Masters Ep. 19: One Piece Void Century Secrets',
      description: 'Decoding Joy Boy, the Ancient Weapons, and the true map of the Grand Line with guest lore analysts.',
      body: 'A deep dive into Eiichiro Oda\'s greatest historical secrets. We connect ancient glyphs, character prophecies, and the will of D.\n\nTotal Runtime: 54 minutes',
      imageUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1200&q=80',
      mediaUrl: 'https://example.com/audio/lore_ep19.mp3',
      durationSeconds: 3240,
      contentType: ContentType.podcast,
      fandomId: 'f7',
      fandomName: 'One Piece',
      tags: ['Podcast', 'Anime', 'One Piece', 'Lore', 'Deep Dive'],
      author: 'Grand Line Radio',
      isFeatured: false,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 54,
      viewCount: 68900,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now(),
    ),
    ContentModel(
      id: 'p3',
      title: 'K-Pop Sound Lab: Decoding the Production of Global Hits',
      description: 'Audio engineer analysis of synths, vocal layering, and bass drops in modern BTS & BLACKPINK records.',
      body: 'Professional music producers break down multi-track stems, arrangement dynamics, and sonic innovation in Asian pop music.',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=1200&q=80',
      mediaUrl: 'https://example.com/audio/kpop_lab_ep07.mp3',
      durationSeconds: 2460,
      contentType: ContentType.podcast,
      fandomId: 'f2',
      fandomName: 'BTS Universe',
      tags: ['Podcast', 'K-Pop', 'Music', 'Production', 'Audio'],
      author: 'Studio Beat Lab',
      isFeatured: false,
      isPublished: true,
      isOfflineAvailable: true,
      readTimeMinutes: 41,
      viewCount: 39400,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
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
              'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800&q=80',
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
              'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
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
              'https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=800&q=80',
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
              'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=800&q=80',
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
              'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80',
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
        EventModel(
          id: 'e7',
          title: 'Comic Con India — Mumbai Fandom Fest',
          description:
              'India\'s grandest pop culture celebration featuring comics, cosplay contests, exclusive international merch, and creator panels.',
          imageUrl:
              'https://images.unsplash.com/photo-1569003339405-ea396a5a8a90?w=800&q=80',
          city: 'Mumbai',
          venue: 'Jio World Convention Centre',
          address: 'BKC, Bandra Kurla Complex, Mumbai, Maharashtra 400051',
          eventDate: DateTime.now().add(const Duration(days: 18)),
          eventEndDate: DateTime.now().add(const Duration(days: 20)),
          category: 'Convention',
          ticketLink: 'https://comicconindia.com',
          latitude: 19.0657,
          longitude: 72.8688,
          isFeatured: true,
          status: 'upcoming',
          attendeeCount: 65_000,
          fandomId: 'f1',
          fandomName: 'Marvel / Anime',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        ),
        EventModel(
          id: 'e8',
          title: 'Delhi Anime & Manga Festival',
          description:
              'Cosplay runway, Japanese food stalls, gaming arenas, voice actor meet & greets in New Delhi.',
          imageUrl:
              'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&q=80',
          city: 'New Delhi',
          venue: 'NSIC Exhibition Ground',
          address: 'Okhla Industrial Estate, New Delhi, Delhi 110020',
          eventDate: DateTime.now().add(const Duration(days: 25)),
          category: 'Convention',
          ticketLink: 'https://delhianimefest.example.com',
          latitude: 28.5447,
          longitude: 77.2642,
          isFeatured: true,
          status: 'upcoming',
          attendeeCount: 30_000,
          fandomId: 'f4',
          fandomName: 'Demon Slayer',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now(),
        ),
        EventModel(
          id: 'e9',
          title: 'Tokyo Anime Expo & Otaku Gathering',
          description:
              'The heart of global anime culture: studios, premier screenings, life-size mecha displays, and exclusive fan showcases.',
          imageUrl:
              'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=800&q=80',
          city: 'Tokyo',
          venue: 'Tokyo Big Sight',
          address: '3 Chome-11-1 Ariake, Koto City, Tokyo 135-0063',
          eventDate: DateTime.now().add(const Duration(days: 40)),
          category: 'Exhibition',
          latitude: 35.6300,
          longitude: 139.7964,
          isFeatured: true,
          status: 'upcoming',
          attendeeCount: 150_000,
          fandomId: 'f1',
          fandomName: 'Attack on Titan',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
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
