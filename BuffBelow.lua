--CURRENT_TARGET_NUM_DEBUFFS
--TARGET_BUFFS_PER_ROW
function BuffSizer_Below()
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
		while (TargetFrame:GetWidth()*0.55) > (BuffSizerDB.buffSize*i) do
			numFirstRowBuffs = i
			i = i + 1	
		end
		
		if ( index == 1 ) then
			if ( UnitIsFriend("player", "target") ) then
				buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", TargetFrame.buffStartX, TargetFrame.buffStartY);
			else
				if ( numDebuffs > 0 ) then
					buff:SetPoint("TOPLEFT", TargetFrameDebuffs, "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
				else
					buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", TargetFrame.buffStartX, TargetFrame.buffStartY);
				end
			end
			TargetFrameBuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..1), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( hasTargetofTarget and index == (2*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( (index > numFirstRowBuffs) and (mod(index+(TARGET_BUFFS_PER_ROW-numFirstRowBuffs), TARGET_BUFFS_PER_ROW) == 1) and not hasTargetofTarget ) then
			-- Make a new row, have to take the number of buffs in the first row into account
			buff:SetPoint("TOPLEFT", getglobal(buffName..(index-TARGET_BUFFS_PER_ROW)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameBuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
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
		while (TargetFrame:GetWidth()*0.55) > (BuffSizerDB.debuffSize*i) do
			numFirstRowBuffs = i
			i = i + 1	
		end
		
		if ( index == 1 ) then
			if ( UnitIsFriend("player", "target") and (numBuffs > 0) ) then
				buff:SetPoint("TOPLEFT", TargetFrameBuffs, "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			else
				buff:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", TargetFrame.buffStartX, TargetFrame.buffStartY);
			end
			TargetFrameDebuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
			TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( index == (numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..1), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( hasTargetofTarget and index == (2*numFirstRowBuffs+1) ) then
			buff:SetPoint("TOPLEFT", getglobal(buffName..(numFirstRowBuffs+1)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
			TargetFrame.buffRows = TargetFrame.buffRows+1;
		elseif ( (index > numFirstRowBuffs) and (mod(index+(TARGET_DEBUFFS_PER_ROW-numFirstRowBuffs), TARGET_DEBUFFS_PER_ROW) == 1) and not hasTargetofTarget ) then
			-- Make a new row
			buff:SetPoint("TOPLEFT", getglobal(buffName..(index-TARGET_DEBUFFS_PER_ROW)), "BOTTOMLEFT", 0, -TargetFrame.buffSpacing);
			TargetFrameDebuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, 0);
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
		local rowSize = 0
		if BuffSizerDB.buffSize < BuffSizerDB.debuffSize then
			rowSize = BuffSizerDB.debuffSize
		else
			rowSize = BuffSizerDB.buffSize
		end
		if ( TargetFrame.buffRows and TargetFrame.buffRows <= 2 ) then
			yPos = 15 + rowSize;
		elseif ( TargetFrame.buffRows ) then
			yPos = 15 + rowSize* TargetFrame.buffRows
		end
		if ( TargetofTargetFrame:IsShown() ) then
			if ( yPos <= 25 ) then
				yPos = yPos + 25;
			end
		else
			yPos = yPos - 5;
			local classification = UnitClassification("target");
			if ( (yPos < rowSize) and ((classification == "worldboss") or (classification == "rareelite") or (classification == "elite") or (classification == "rare")) ) then
				yPos = rowSize;
			end
		end
		TargetFrameSpellBar:SetPoint("BOTTOM", "TargetFrame", "BOTTOM", -15, -yPos);
	end
end