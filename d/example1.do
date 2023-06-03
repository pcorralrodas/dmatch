clear all
run "C:\Users\wb378870\OneDrive - WBG\000.my_ados\dmatch\dmatch.ado"
sysuse auto, clear
	set seed 12345
	gen id=_n
	gen random = runiformint(1,74)
	
	gen target = 1 if random < 11
		replace target = 0 if target == .
		
	replace weight = . if random < 11
	replace trunk = . if random < 11 
	
	
dmatch length weight trunk, uniqid(id) todata(target) strata(foreign) trimvar(length)  