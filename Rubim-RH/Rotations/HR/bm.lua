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
local mainAddon = RubimRH

-- Spells
RubimRH.Spell[253] = {
    ArcaneTorrent = Spell(80483),
    AncestralCall = Spell(274738),
    Berserking = Spell(26297),
    BerserkingBuff = Spell(26297),
    BloodFury = Spell(20572),
    BloodFuryBuff = Spell(20572),
    Fireblood = Spell(265221),
    GiftoftheNaaru = Spell(59547),
    LightsJudgment = Spell(255647),
    Shadowmeld = Spell(58984),
    CallPet = Spell(883),
    MendPet = Spell(136),
    RevivePet = Spell(982),
    AspectoftheWild = Spell(193530),
	WildSpirits = Spell(328231),
    BarbedShot = Spell(217200),
    Frenzy = Spell(272790),
    BeastCleaveBuff = Spell(268877),
    BestialWrath = Spell(19574),
    BestialWrathBuff = Spell(19574),
    CobraShot = Spell(193455),
	KillShot = Spell(53351),
    KillCommand = Spell(34026),
    Multishot = Spell(2643),
    AMurderofCrows = Spell(131894),
    AnimalCompanion = Spell(267116),
    AspectoftheBeast = Spell(191384),
    Barrage = Spell(120360),
    BindingShot = Spell(109248),
    ChimaeraShot = Spell(53209),
    DireBeast = Spell(120679),
    KillerInstinct = Spell(273887),
    OnewiththePack = Spell(199528),
    ScentofBlood = Spell(193532),
    SpittingCobra = Spell(194407),
    Stampede = Spell(201430),
    ThrilloftheHunt = Spell(257944),
    VenomousBite = Spell(257891),
    AspectoftheTurtle = Spell(186265),
    Exhilaration = Spell(109304),
    AspectoftheCheetah = Spell(186257),
    CounterShot = Spell(147362),
    TranqShot = Spell(19801),
    Disengage = Spell(781),
    FreezingTrap = Spell(187650),
    FeignDeath = Spell(5384),
    TarTrap = Spell(187698),
    ConcusiveShot = Spell(5116),
    Intimidation = Spell(19577),
	BloodBolt = Spell(288962),
	SoulShape = Spell(310143),
	foodanddrink = Spell(308433),
	Flare = Spell(1543),
}
local S = RubimRH.Spell[253]

if not Item.Hunter then Item.Hunter = {}; end

Item.Hunter.BeastMastery = {


};
local I = Item.Hunter.BeastMastery;

local function PetActive()
    local petActive = false
    if Pet:Exists() then
        petActive = true
    end

    if Pet:IsActive() then
        petActive = true
    end

    if Pet:IsDeadOrGhost() then
        petActive = false
    end

    return petActive
end

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

local function CleaveCount()
local cleave_counter = 0
     
        for i=1,40 do
            if UnitExists("nameplate"..i) then           
                local nameplate_guid = UnitGUID("nameplate"..i) 
                local npc_id = select(6, strsplit("-",nameplate_guid))
                if npc_id ~='120651' and npc_id ~='161895' then
                    if IsActionInRange(37,"nameplate"..i) then
                        cleave_counter = cleave_counter+1
                    end                    
                end
            end
        end
    
    return cleave_counter
end

local function APL()
local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("target")
HL.GetEnemies(25, true);

if Player:IsCasting() or Player:IsChanneling() or Player:BuffP(S.foodanddrink) or Player:BuffP(S.FeignDeath) or Player:BuffP(S.AspectoftheTurtle) or Player:BuffP(S.SoulShape) then
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

--OUT OF COMBAT
	if not Player:AffectingCombat() then
	
		-- if S.MendPet:IsCastable() and Pet:IsActive() and Cache.EnemiesCount[25] == 0 and Pet:HealthPercentage() > 0 and Pet:HealthPercentage() <= 85 and not Pet:Buff(S.MendPet) then
			-- return S.MendPet:Cast()
		-- end
	
	end

--INTERRUPTS
	if notInterruptible == false and Target:CastPercentage() > 27 and RubimRH.InterruptsON() and S.CounterShot:IsReady(8) and Target:AffectingCombat() then
		return S.CounterShot:Cast()
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

--ROTATION
	if (Player:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) then
	
		-- if S.Exhilaration:IsCastable() and Player:HealthPercentage() <= 35 then
			-- return S.Exhilaration:Cast()
		-- end

		if S.AspectoftheWild:IsCastable() and Player:BuffRemains(S.BestialWrath) >= 13 and RubimRH.CDsON() then
			return S.AspectoftheWild:Cast()
		end

		-- if S.BarbedShot:IsReady(40) and (S.BarbedShot:FullRechargeTimeP() <= Player:GCD() or (Pet:Buff(S.Frenzy) and Pet:BuffRemains(S.Frenzy) <= Player:GCD() * 1.2)) then
			-- return S.BarbedShot:Cast()
		-- end
		
		if S.BarbedShot:IsReady(40) and Pet:Buff(S.Frenzy) and Pet:BuffRemains(S.Frenzy) <= Player:GCD() * 1.1 then
			return S.BarbedShot:Cast()
		end
		
		if S.Multishot:IsReady(40) and (CleaveCount() >= 2 and Player:GCD() - Player:BuffRemainsP(S.BeastCleaveBuff) > 0.25) then
			return S.Multishot:Cast()
		end
		
		if S.KillShot:IsReady(40) then
			return S.KillShot:Cast()
		end
		
		if S.BarbedShot:IsReady(40) and S.BarbedShot:FullRechargeTimeP() <= Player:GCD() then
			return S.BarbedShot:Cast()
		end
		
		if S.KillCommand:IsReady(50) and Pet:IsActive() then
			return S.KillCommand:Cast()
		end
		
		if S.CobraShot:IsReady(40) and ((CleaveCount() < 2 or S.KillCommand:CooldownRemainsP() > Player:FocusTimeToMaxPredicted()) and (Player:Focus() - S.CobraShot:Cost() + Player:FocusRegen() * (S.KillCommand:CooldownRemainsP() - 1) > S.KillCommand:Cost() or S.KillCommand:CooldownRemainsP() > 1 + Player:GCD()) and S.KillCommand:CooldownRemainsP() > 1) then
			return S.CobraShot:Cast()
		end
		
	end


    return 0, "Interface\\Addons\\Rubim-RH\\Media\\mount2.tga"
end

RubimRH.Rotation.SetAPL(253, APL);

local function PASSIVE()


end

RubimRH.Rotation.SetPASSIVE(253, PASSIVE);