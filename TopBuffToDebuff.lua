--CURRENT_TARGET_NUM_DEBUFFS
--TARGET_BUFFS_PER_ROW
function BuffSizer_TopBuffToDebuff()
	local targetBuffSize = BuffSizerDB.buffSize
	local targetDebuffSize = BuffSizerDB.debuffSize
	local buffOffset = BuffSizerDB.buffOffset
	local debuffOffset = BuffSizerDB.debuffOffset



	-- Update buff positioning/size
	function TargetFrame_UpdateBuffAnchor(buffName, index, numFirstRowBuffs, numDebuffs, buffSize, offset, ...)
		local buff = getglobal(buffName..index);
		buffSize = BuffSizerDB.buffSize
		offset = buffOffset
		-- buff/debuff area is ~55% of the frame, portait comes after that
		local i = 1
		while (TargetFrame:GetWidth()*0.8) > (BuffSizerDB.buffSize*i) do
			numFirstRowBuffs = i
			TARGET_BUFFS_PER_ROW = i
			i = i + 1	
		end
		
		if ( index == 1 ) then
			if ( UnitIsFriend("player", "target") ) then
				buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -20);
			else
				--if ( numDebuffs > 0 ) then
					--buff:SetPoint("BOTTOMLEFT", TargetFrameDebuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
				--else
					buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -20);
				--end
			end
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..1), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( (index > numFirstRowBuffs) and (mod(index+(TARGET_BUFFS_PER_ROW-numFirstRowBuffs), TARGET_BUFFS_PER_ROW) == 1)) then
			-- Make a new row, have to take the number of buffs in the first row into account
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(index-TARGET_BUFFS_PER_ROW)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		else
			-- Just anchor to previous
			buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
		end

		-- Resize
		buff:SetWidth(buffSize);
		buff:SetHeight(buffSize);
	end

	-- Update debuff positioning/size
	function TargetFrame_UpdateDebuffAnchor(buffName, index, numFirstRowBuffs, numBuffs, buffSize, offset, ...)
		local buff = getglobal(buffName..index);
		buffSize = BuffSizerDB.debuffSize
		offset = debuffOffset
		-- buff/debuff area is ~55% of the frame, portait comes after that
		local i = 1
		while (TargetFrame:GetWidth()*0.8) > (BuffSizerDB.debuffSize*i) do
			numFirstRowBuffs = i
			TARGET_BUFFS_PER_ROW = i
			i = i + 1	
		end
		
		if ( index == 1 ) then
			if ( UnitIsFriend("player", "target") and (numBuffs > 0) ) then
				buff:SetPoint("BOTTOMLEFT", TargetFrameBuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
			else
				if ( numBuffs > 0 ) then
					buff:SetPoint("BOTTOMLEFT", TargetFrameBuffs, "TOPLEFT", 0, TargetFrame.buffSpacing);
				else
					buff:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -20);
				end
			end
			TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..1), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( (index > numFirstRowBuffs) and (mod(index+(TARGET_DEBUFFS_PER_ROW-numFirstRowBuffs), TARGET_DEBUFFS_PER_ROW) == 1)) then
			-- Make a new row
			buff:SetPoint("BOTTOMLEFT", getglobal(buffName..(index-TARGET_DEBUFFS_PER_ROW)), "TOPLEFT", 0, TargetFrame.buffSpacing);
			TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		else
			-- Just anchor to previous
			buff:SetPoint("TOPLEFT", getglobal(buffName..(index-1)), "TOPRIGHT", offset, 0);
		end
		
		-- Resize
		buff:SetWidth(buffSize);
		buff:SetHeight(buffSize);
		local debuffFrame = getglobal(buffName..index.."Border");
		debuffFrame:SetWidth(buffSize+2);
		debuffFrame:SetHeight(buffSize+2);
	end

	function Target_Spellbar_AdjustPosition()
		local yPos = 5;
		if ( TargetofTargetFrame:IsShown() ) then
			if ( yPos <= 25 ) then
				yPos = yPos + 25;
			end
		else
			yPos = yPos - 5;
			local classification = UnitClassification("target");
			if ( (yPos < 17) and ((classification == "worldboss") or (classification == "rareelite") or (classification == "elite") or (classification == "rare")) ) then
				yPos = 17;
			end
		end
		TargetFrameSpellBar:SetPoint("BOTTOM", "TargetFrame", "BOTTOM", -15, -yPos);
	end
end