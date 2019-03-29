function loadARGS(dic)
    #now we add whatever arguments the user wants
    for line in ARGS
    	s = split(line , dic["ArgDelimiter"])
    	if (length(s)==2)
    		try
    			dic[s[1]]=s[2] #as a computer science student I find arrays not starting at zero blasphemous

    		catch e
    			println(e)
    		end

    	end
    end
return dic
end
