--- Localize Vars
-- Addon
local addonName, addonTable = ...;
-- HeroLib
local HL = HeroLib;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Pet = Unit.Pet;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;
-- Spells

--Survival
RubimRH.Spell[255] = {
    --Racials
    -- Racials
    Berserking = Spell(26297),
    BloodFury = Spell(20572),
    AncestralCall = Spell(274738),
    Fireblood = Spell(265221),
    LightsJudgment = Spell(255647),
    ArcaneTorrent = Spell(80483),
    BerserkingBuff = Spell(26297),
    BloodFuryBuff = Spell(20572),
    -- Abilities
    Harpoon = Spell(190925),
    CoordinatedAssault = Spell(266779),
    KillCommand = Spell(259489),
    CoordinatedAssaultBuff = Spell(266779),
    Carve = Spell(187708),
    SerpentSting = Spell(259491),
    RaptorStrikeEagle = Spell(265189),
    RaptorStrike = Spell(186270),
    CounterShot = Spell(147362),
	Steward = Spell(324739),
    -- Pet
    CallPet = Spell(883),
    Intimidation = Spell(19577),
    MendPet = Spell(136),
    RevivePet = Spell(982),
    -- Talents
    SteelTrapDebuff = Spell(162487),
    SteelTrap = Spell(162488),
    AMurderofCrows = Spell(131894),
    PheromoneBomb = Spell(270323),
    VolatileBomb = Spell(271045),
    ShrapnelBomb = Spell(270335),
    ShrapnelBombDebuff = Spell(270339),
    WildfireBomb = Spell(259495),
    FeignDeath = Spell(5384),
    GuerrillaTactics = Spell(264332),
    WildfireBombDebuff = Spell(269747),
    Chakrams = Spell(259391),
    Butchery = Spell(212436),
	foodanddrink = Spell(308433),
    WildfireInfusion = Spell(271014),
    InternalBleedingDebuff = Spell(270343),
    FlankingStrike = Spell(269751),
    VipersVenomBuff = Spell(268552),
    KillShot = Spell(320976),
    TermsofEngagement = Spell(265895),
    TipoftheSpearBuff = Spell(260286),
    MongooseBiteEagle = Spell(265888),
    MongooseBite = Spell(259387),
    BirdsofPrey = Spell(260331),
    MongooseFuryBuff = Spell(259388),
    VipersVenom = Spell(268501),
    -- Defensive
    AspectoftheTurtle = Spell(186265),
    Exhilaration = Spell(109304),
    -- Utility
    FreezingTrap = Spell(187650),
    AspectoftheEagle = Spell(186289),
    Muzzle = Spell(187707),
    TranqShot = Spell(19801),
    -- PvP
    WingClip = Spell(195645),
    LatentPoison = Spell(273284),
    LatentPoisonDebuff = Spell(273286),
    HydrasBite = Spell(260241),
	ResonatingArrow = Spell(308491),
};

local S = RubimRH.Spell[255]
local VarCarveCdr = 0;

S.MongooseBite.TextureSpellID = { 224795 } -- Raptor Strikes
S.Butchery.TextureSpellID = { 203673 } -- Carve
S.ShrapnelBomb.TextureSpellID = { 269747 }
S.PheromoneBomb.TextureSpellID = { 269747 }
S.VolatileBomb.TextureSpellID = { 269747 }
S.WildfireBomb.TextureSpellID = { 269747 }
S.WingClip.TextureSpellID = { 76151 }

-- Items
if not Item.Hunter then
    Item.Hunter = {}
end

Item.Hunter.Survival = {
	phialofserenity = Item(177278),

};

local function UpdateWFB()
    if S.ShrapnelBomb:IsReadyMorph() then
        S.WildfireBomb = Spell(270335)
    elseif S.VolatileBomb:IsReadyMorph() then
        S.WildfireBomb = Spell(271045)
    elseif S.PheromoneBomb:IsReadyMorph() then
        S.WildfireBomb = Spell(270323)
    else
        S.WildfireBomb = Spell(259495)
    end
    S.ShrapnelBomb.TextureSpellID = { 269747 }
    S.PheromoneBomb.TextureSpellID = { 269747 }
    S.VolatileBomb.TextureSpellID = { 269747 }
    S.WildfireBomb.TextureSpellID = { 269747 }
end

-- Variables
local VarCanGcd = 0;
-- Rotation Var
local ShouldReturn;
local EnemyRanges = { 8, 40, "Melee" }
local function UpdateRanges()
    for _, i in ipairs(EnemyRanges) do
        HL.GetEnemies(i);
    end
end

local function num(val)
    if val then
        return 1
    else
        return 0
    end
end

local function bool(val)
    return val ~= 0
end

local I = Item.Hunter.Survival;

local function shouldTranq()
local namex, iconx, stacksx, debuffClassx, durationx, expirationTimex, unitCasterx, isStealablex, spellIdx, isBossDebuffx, isCastByPlayerx = UnitAura("target", 1)


	if debuffClassx == nil then
        debuffClassx = "none"
    elseif debuffClassx == "" then
        debuffClassx = "enrage"
    else
        debuffClassx = string.lower(debuffClassx)
    end

	if debuffClassx == "enrage" then 
		return true
	else
		return false
	end

end 



--- APL Main
local function APL ()
local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("target")
HL.GetEnemies(25, true);
	HL.GetEnemies("Melee");
	HL.GetEnemies(5, true);
    HL.GetEnemies(8, true);
    HL.GetEnemies(10, true);
	HL.GetEnemies(20, true);
	HL.GetEnemies(40, true);

if Player:IsCasting() or Player:IsChanneling() or Player:BuffP(S.foodanddrink) or Player:BuffP(S.FeignDeath) or Player:BuffP(S.AspectoftheTurtle) then
	return 0, "Interface\\Addons\\Rubim-RH\\Media\\channel.tga"
end 

--QUEUE
	if not RubimRH.queuedSpell[1]:CooldownUp() or not Target:IsInRange(40) or not Player:AffectingCombat() then
		RubimRH.queuedSpell = { RubimRH.Spell[1].Empty, 0 }
	end
	
	if S.FreezingTrap:ID() == RubimRH.queuedSpell[1]:ID() then
    	return S.TarTrap:Cast()
	end
	
	if RubimRH.QueuedSpell():IsReadyQueue() then
        return RubimRH.QueuedSpell():Cast()
    end

--INTERRUPTS
	if notInterruptible == false and Target:CastPercentage() > 27 and RubimRH.InterruptsON() and S.Muzzle:IsReady(8) and Target:AffectingCombat() then
		return S.Muzzle:Cast()
	end
	
	if (shouldTranq() 
     or AuraUtil.FindAuraByName("Undying Rage", "target") 
     or AuraUtil.FindAuraByName("Enrage", "target") 
     or AuraUtil.FindAuraByName("Unholy Frenzy", "target")
     or AuraUtil.FindAuraByName("Angering Shriek", "target")
     or AuraUtil.FindAuraByName("Loyal Beasts", "target")
     or AuraUtil.FindAuraByName("Frenzy", "target")
     or AuraUtil.FindAuraByName("Motivational Clubbing", "target")
     or AuraUtil.FindAuraByName("Motivated", "target")
     or AuraUtil.FindAuraByName("Seething Rage", "target")
     or AuraUtil.FindAuraByName("Vengeful Rage", "target")
     or AuraUtil.FindAuraByName("Raging Tantrum", "target")
     or AuraUtil.FindAuraByName("Death Wish", "target")
     or AuraUtil.FindAuraByName("Battle Trance", "target")
     ) 
     and RubimRH.InterruptsON() and S.TranqShot:IsReady() and Target:AffectingCombat() and Target:TimeToDie() > 4 then
        return S.TranqShot:Cast()
    end
	
--OUT OF COMBAT
	if not Player:AffectingCombat() then
	
	if S.Steward:IsCastable() and I.phialofserenity:Count() <= 1 and Cache.EnemiesCount[20] == 0 then
        return S.Steward:Cast()
    end
	
	end

--ROTATION
	if (Player:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) then

		if S.Carve:IsReady("Melee") and Cache.EnemiesCount[10] > 1 and S.WildfireBomb:FullRechargeTimeP() > Player:GCD() then
			return S.Carve:Cast()
		end

		if (S.WildfireBomb:IsReadyMorph(40) or S.VolatileBomb:IsReadyMorph(40) or S.ShrapnelBomb:IsReadyMorph(40) or S.PheromoneBomb:IsReadyMorph(40)) and Cache.EnemiesCount[10] > 1 then
			return S.WildfireBomb:Cast()
		end

		if S.SerpentSting:IsReady(40) and not Target:DebuffP(S.SerpentSting) then
			return S.SerpentSting:Cast()
		end

		if S.KillShot:IsReady(40) then
			return S.KillShot:Cast()
		end
		
		if (S.WildfireBomb:IsReadyMorph(40) or S.VolatileBomb:IsReadyMorph(40) or S.ShrapnelBomb:IsReadyMorph(40) or S.PheromoneBomb:IsReadyMorph(40)) and S.WildfireBomb:FullRechargeTimeP() <= Player:GCD() then
			return S.WildfireBomb:Cast()
		end

		if S.KillCommand:IsReady() and Player:FocusTimeToMaxPredicted() >= Player:GCD() then
			return S.KillCommand:Cast()
		end
	
		if S.SerpentSting:IsReady(40) and Target:DebuffRemainsP(S.SerpentSting) <= Player:GCD() then
			return S.SerpentSting:Cast()
		end
		
		if S.RaptorStrike:IsReady("Melee") and Player:Focus() >= 50 then
			return S.RaptorStrike:Cast()
		end
		
	end


    return 0, "Interface\\Addons\\Rubim-RH\\Media\\mount2.tga"
end

RubimRH.Rotation.SetAPL(255, APL);

local function PASSIVE()

end

RubimRH.Rotation.SetPASSIVE(255, PASSIVE);
