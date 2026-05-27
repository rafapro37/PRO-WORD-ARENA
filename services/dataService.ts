
import { AppState, UserRole, PlanType, UserStatus, User, PlayerProfile, Tournament, Team, Match, Player, TournamentFormat, FinalFormat, SportType, ContractInvitation, TournamentRegistration, ClubPlayer, ExperienceType } from '../types';
import { POSITIONS, MARKET_KEY } from '../constants';
import { supabase } from './supabase';

const STORAGE_KEY = 'pro_world_arena_db_v1';

// --- SUPABASE HELPERS ---

export const fetchAllFromSupabase = async (): Promise<Partial<AppState>> => {
  const results: Partial<AppState> = {};
  
  try {
    const [
      { data: users },
      { data: profiles },
      { data: tournaments },
      { data: teams },
      { data: matches },
      { data: players },
      { data: news },
      { data: ads },
      { data: registrations },
      { data: leagues },
      { data: leagueInvitations },
      { data: leagueMembers },
      { data: marketPlayers },
      { data: proposals },
      { data: transferHistory },
    ] = await Promise.all([
      supabase.from('usuarios').select('*'),
      supabase.from('perfis').select('*'),
      supabase.from('campeonatos').select('*'),
      supabase.from('times').select('*'),
      supabase.from('partidas').select('*'),
      supabase.from('jogadores').select('*'),
      supabase.from('noticias').select('*'),
      supabase.from('anuncios').select('*'),
      supabase.from('participantes').select('*'),
      supabase.from('federacoes').select('*'),
      supabase.from('convites_liga').select('*'),
      supabase.from('mercado_transferencias').select('*'),
      supabase.from('mercado_transferencias').select('*'),
      supabase.from('propostas').select('*'),
      supabase.from('movimentacoes').select('*'),
    ]);

    if (users)           results.users                  = users;
    if (profiles)        results.playerProfiles          = profiles;
    if (tournaments)     results.tournaments             = tournaments;
    if (teams)           results.teams                   = teams;
    if (matches)         results.matches                 = matches;
    if (players)         results.players                 = players;
    if (news)            results.news                    = news;
    if (ads)             results.ads                     = ads;
    if (registrations)   results.registrations           = registrations;
    if (leagues)         results.leagues                 = leagues;
    if (leagueInvitations) results.leagueInvitations     = leagueInvitations;
    if (leagueMembers)   results.leagueMembers           = leagueMembers;
    if (marketPlayers)   results.marketPlayers           = marketPlayers;
    if (proposals)       results.propostas               = proposals;
    if (transferHistory) results.historicoTransferencias = transferHistory;

  } catch (error) {
    console.error('Erro ao buscar dados do Supabase:', error);
  }

  return results;
};

export const syncToSupabase = async (table: string, data: any[]) => {
  if (!data || data.length === 0) return;
  try {
    const { error } = await supabase.from(table).upsert(data, { onConflict: 'id' });
    if (error) {
       console.warn(`Supabase sync warning on table ${table}:`, error.message);
    }
  } catch (error) {
    console.error(`Supabase sync failure on table ${table}:`, error);
  }
};

const INITIAL_STATE: AppState = {
  currentUser: null,
  users: [],
  playerProfiles: [],
  contractInvitations: [], // Init empty
  tournaments: [],
  registrations: [], // New registrations array
  teams: [],
  matches: [],
  players: [],
  ads: [],
  news: [],
  propostas: [],
  planConfigs: {
    [PlanType.FREE]: {
      type: PlanType.FREE,
      name: 'Grátis',
      price: 'R$ 0,00',
      maxGroups: 1,
      maxTeams: 4,
      canExport: false,
      customization: false
    },
    [PlanType.BASIC]: {
      type: PlanType.BASIC,
      name: 'Básico',
      price: 'R$ 19,90',
      maxGroups: 4,
      maxTeams: 16,
      canExport: false,
      customization: false
    },
    [PlanType.PRO]: {
      type: PlanType.PRO,
      name: 'Pro',
      price: 'R$ 39,90',
      maxGroups: 12,
      maxTeams: 48,
      canExport: true,
      customization: false
    },
    [PlanType.ELITE]: {
      type: PlanType.ELITE,
      name: 'Elite',
      price: 'R$ 79,90',
      maxGroups: 999,
      maxTeams: 999,
      canExport: true,
      customization: true
    }
  },
  settings: {
    adminWhatsapp: '',
    supportButtonText: 'Suporte Técnico VIP',
    loginLogoUrl: '',
    loginBannerLogoUrl: '',
    loginBackgroundUrl: '',
    loginBackgroundSize: 'cover',
    socialLinks: [
        { id: '1', platform: 'INSTAGRAM', url: 'https://instagram.com' },
        { id: '2', platform: 'WEBSITE', url: 'https://google.com' }
    ],
    defaultTournamentDurationDays: 30,
    globalTheme: { corPrimaria: '#FF6A00', background: '#1A1C22', superficie: '#20242D', texto: '#F2F2F2' },
    loginLayout: {
        mode: 'STANDARD',
        brandingPos: { x: 5, y: 80 },
        formPos: { x: 85, y: 50 },
        plansPos: { x: 25, y: 50, scale: 100 },
        socialPos: { x: 50, y: 90, visible: true }
    },
    brandingTextPrimary: 'PRO WORLD',
    brandingTextSecondary: 'ARENA',
    brandingSlogan: 'A plataforma definitiva para seu campeonato.',
    bracketStyle: 'CLASSIC',
    enableExternalCarousel: true,
    enableThemedBackground: true, // Default true
    playerCustomization: {
        bgColor: '#1A1A1A',
        textColor: '#FFFFFF',
        borderColor: '#FF6A00',
        borderRadius: '9999px',
        shape: 'circle',
        borderEnabled: true,
        borderWidth: 2,
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: 'normal',
        nameTagStyle: 'simple',
        layout: 'nameBelow'
    },
    globalImages: {
        homeBg: '',
        loginBg: '',
        logo: ''
    }
  },
  systemLogs: [], // Init Change Log
  negotiations: [],
  marketSettings: [],
  marketPlayers: [],
  adminPlayerBank: [],
  gamePlans: [],
  historicoTransferencias: [],
  marketStatuses: {},
  leagues: [],
  leagueInvitations: [],
  leagueMembers: [],
  planUpgradeRequests: []
};

// REGRAS DE ID: ÚNICO, PERMANENTE, BASEADO EM TIMESTAMP
export const generateId = () => {
    // Usa Date.now() string base + pequeno random para evitar colisão em loops de criação em massa
    return Date.now().toString() + Math.floor(Math.random() * 1000).toString();
};

export const loadState = (): AppState => {
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    const session = localStorage.getItem('pro_world_arena_session_v1');
    
    let parsed: any = {};
    if (stored) {
      parsed = JSON.parse(stored);
    }

    if (session) {
        parsed.currentUser = JSON.parse(session);
    }

    if (parsed.users) {
        parsed.users = parsed.users.map((u: User) => {
            if (!u.id) u.id = generateId();
            return u;
        });
    }

    const realUsers = (parsed.users || []).filter((u: User) => !u.id.startsWith('mock_'));
    const realProfiles = (parsed.playerProfiles || []).filter((p: PlayerProfile) => !p.userId.startsWith('mock_'));

    return { 
      ...INITIAL_STATE, 
      ...parsed,
      users: realUsers,
      playerProfiles: realProfiles,
      settings: { 
          ...INITIAL_STATE.settings, 
          ...(parsed.settings || {}),
          globalTheme: parsed.settings?.globalTheme || { corPrimaria: '#FF6A00', background: '#1A1C22', superficie: '#20242D', texto: '#F2F2F2' },
      },
      planConfigs: { ...INITIAL_STATE.planConfigs, ...(parsed.planConfigs || {}) }
    };
  } catch (e) {
    console.error("Failed to load local state", e);
  }
  return INITIAL_STATE;
};

export const saveState = (state: AppState) => {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    if (state.currentUser) {
        localStorage.setItem('pro_world_arena_session_v1', JSON.stringify(state.currentUser));
    }
  } catch (e: any) {
    console.error("Local save error:", e);
  }
};

export const clearStorage = () => {
    localStorage.removeItem(STORAGE_KEY);
    localStorage.removeItem('pro_world_arena_session_v1');
};

// ... (rest of the file remains unchanged, mock scenarios etc)
// --- GENERATE TEST SCENARIO ---
export const generateTestScenario = (currentAdminId: string): Partial<AppState> => {
    // CRITICAL FIX: If generated by Dev Admin, assign to Dev Organizer so they can see/edit it.
    const organizerId = currentAdminId === 'dev_admin_fixed' ? 'dev_org_fixed' : currentAdminId;

    const tournaments: Tournament[] = [];
    const teams: Team[] = [];
    const players: Player[] = [];
    const matches: Match[] = [];

    // Helper to create a team with players
    const createTeam = (name: string, tourneyId: string, groupId: string) => {
        const teamId = generateId();
        const team: Team = {
            id: teamId,
            organizadorId: organizerId,
            name,
            tournamentId: tourneyId,
            groupId,
            played: 0, won: 0, drawn: 0, lost: 0, goalsFor: 0, goalsAgainst: 0, points: 0
        };
        teams.push(team);

        // NO DUMMY PLAYERS ADDED HERE
        return teamId;
    };

    // 1. LEAGUE (Pontos Corridos)
    const leagueId = generateId();
    const leagueGroup = generateId();
    tournaments.push({
        id: leagueId,
        organizadorId: organizerId,
        name: 'Liga Teste (Pontos Corridos)',
        sport: SportType.VIRTUAL,
        format: TournamentFormat.LEAGUE,
        experienceType: ExperienceType.X1,

        status: 'ACTIVE',
        tournamentType: 'X1',
        groups: [{ id: leagueGroup, name: 'Tabela Geral' }],
        currentRound: 0,
        doubleRoundRobin: true,
        finalFormat: FinalFormat.SINGLE,
        createdAt: Date.now(),
        bannerUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=1936&auto=format&fit=crop'
    });
    ['Flamengo', 'Palmeiras', 'São Paulo', 'Corinthians', 'Vasco', 'Botafogo'].forEach(name => createTeam(name, leagueId, leagueGroup));

    // 2. GROUPS (Fase de Grupos)
    const groupsId = generateId();
    const g1 = generateId();
    const g2 = generateId();
    tournaments.push({
        id: groupsId,
        organizadorId: organizerId,
        name: 'Copa Teste (Grupos)',
        sport: SportType.FIELD,
        format: TournamentFormat.GROUPS,
        experienceType: ExperienceType.X1,

        status: 'ACTIVE',
        tournamentType: 'X1',
        groups: [{ id: g1, name: 'Grupo A' }, { id: g2, name: 'Grupo B' }],
        currentRound: 0,
        doubleRoundRobin: false,
        hasBestThird: false,
        finalFormat: FinalFormat.SINGLE,
        createdAt: Date.now(),
        bannerUrl: 'https://images.unsplash.com/photo-1627916560965-09c06587d540?q=80&w=2070&auto=format&fit=crop'
    });
    ['Real Madrid', 'Man City', 'Bayern'].forEach(name => createTeam(name, groupsId, g1));
    ['Barcelona', 'Liverpool', 'PSG'].forEach(name => createTeam(name, groupsId, g2));

    // 3. KNOCKOUT (Mata-Mata Completo - 3 Rounds)
    const koId = generateId();
    const koGroup = generateId();
    tournaments.push({
        id: koId,
        organizadorId: organizerId,
        name: 'Mata-Mata Teste',
        sport: SportType.FUTSAL,
        format: TournamentFormat.KNOCKOUT,
        experienceType: ExperienceType.X1,

        status: 'ACTIVE',
        tournamentType: 'X1',
        groups: [{ id: koGroup, name: 'Chaveamento' }],
        currentRound: 3, 
        doubleRoundRobin: false,
        finalFormat: FinalFormat.SINGLE,
        createdAt: Date.now(),
        bannerUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0565c6a?q=80&w=2070&auto=format&fit=crop'
    });
    
    const koTeams: {id: string, name: string}[] = [];
    ['Brasil', 'Argentina', 'França', 'Alemanha', 'Espanha', 'Itália', 'Portugal', 'Holanda'].forEach(name => {
        const id = createTeam(name, koId, koGroup);
        koTeams.push({id, name});
    });

    // QF
    matches.push({ id: generateId(), organizadorId: organizerId, tournamentId: koId, groupId: koGroup, homeTeamId: koTeams[0].id, awayTeamId: koTeams[1].id, homeScore: 3, awayScore: 1, round: 1, isFinished: true, events: [] });
    matches.push({ id: generateId(), organizadorId: organizerId, tournamentId: koId, groupId: koGroup, homeTeamId: koTeams[2].id, awayTeamId: koTeams[3].id, homeScore: 0, awayScore: 2, round: 1, isFinished: true, events: [] });
    matches.push({ id: generateId(), organizadorId: organizerId, tournamentId: koId, groupId: koGroup, homeTeamId: koTeams[4].id, awayTeamId: koTeams[5].id, homeScore: 1, awayScore: 0, round: 1, isFinished: true, events: [] });
    matches.push({ id: generateId(), organizadorId: organizerId, tournamentId: koId, groupId: koGroup, homeTeamId: koTeams[6].id, awayTeamId: koTeams[7].id, homeScore: 2, awayScore: 2, round: 1, isFinished: true, events: [] });

    // SF
    matches.push({ id: generateId(), organizadorId: organizerId, tournamentId: koId, groupId: koGroup, homeTeamId: koTeams[0].id, awayTeamId: koTeams[3].id, homeScore: 2, awayScore: 1, round: 2, isFinished: true, events: [] });
    matches.push({ id: generateId(), organizadorId: organizerId, tournamentId: koId, groupId: koGroup, homeTeamId: koTeams[4].id, awayTeamId: koTeams[7].id, homeScore: null, awayScore: null, round: 2, isFinished: false, events: [] });

    // Final
    matches.push({ id: generateId(), organizadorId: organizerId, tournamentId: koId, groupId: koGroup, homeTeamId: koTeams[0].id, awayTeamId: 'TBD', homeScore: null, awayScore: null, round: 3, isFinished: false, events: [] });

    // 4. WORLD CUP SIMULATION (32 Teams, 8 Groups - READY FOR KNOCKOUT)
    const wcId = generateId();
    const wcGroups = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map(l => ({ id: generateId(), name: `Grupo ${l}` }));

    tournaments.push({
        id: wcId,
        organizadorId: organizerId,
        name: 'Copa do Mundo 2026 (Simulação)',
        sport: SportType.FIELD,
        format: TournamentFormat.GROUPS,
        experienceType: ExperienceType.X1,

        status: 'ACTIVE',
        tournamentType: 'X1',
        groups: wcGroups,
        currentRound: 3,
        doubleRoundRobin: false,
        finalFormat: FinalFormat.SINGLE,
        createdAt: Date.now(),
        bannerUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=2070&auto=format&fit=crop'
    });

    // Create Teams & FULLY FINISHED MATCHES
    wcGroups.forEach((group, gIdx) => {
        const groupTeams: Team[] = [];
        // 4 teams per group
        for(let i=1; i<=4; i++) {
            const tId = createTeam(`Seleção ${group.name.split(' ')[1]}-${i}`, wcId, group.id);
            const t = teams.find(tm => tm.id === tId)!;
            groupTeams.push(t);
        }

        // Generate All vs All matches
        for(let i=0; i<groupTeams.length; i++) {
            for(let j=i+1; j<groupTeams.length; j++) {
                // Ensure distinct results to avoid tie-breaker hell for testing
                // i=0 wins everything, i=1 wins rest, etc.
                const finalScoreA = i === 0 ? 3 : (i === 1 && j > 1 ? 2 : 0);
                const finalScoreB = j === 0 ? 3 : (j === 1 && i > 1 ? 2 : (i < j ? 0 : 1));
                
                // Override for randomness but keeping hierarchy
                const scoreA = (4-i); // Team 0 gets 4 goals, Team 3 gets 1
                const scoreB = (4-j); 

                matches.push({
                    id: generateId(),
                    organizadorId: organizerId,
                    tournamentId: wcId,
                    groupId: group.id,
                    homeTeamId: groupTeams[i].id,
                    awayTeamId: groupTeams[j].id,
                    homeScore: scoreA,
                    awayScore: scoreB,
                    round: 1, 
                    isFinished: true, // CRITICAL: ALL FINISHED
                    events: [],
                    stage: 'GROUP'
                });
                
                // Update stats locally
                const tA = groupTeams[i];
                const tB = groupTeams[j];
                tA.played++; tB.played++;
                tA.goalsFor += scoreA; tA.goalsAgainst += scoreB;
                tB.goalsFor += scoreB; tB.goalsAgainst += scoreA;
                
                if(scoreA > scoreB) {
                    tA.won++; tA.points += 3; tB.lost++;
                } else if(scoreB > scoreA) {
                    tB.won++; tB.points += 3; tA.lost++;
                } else {
                    tA.drawn++; tA.points += 1; tB.drawn++; tB.points += 1;
                }
            }
        }
    });

    return { tournaments, teams, players, matches };
};
