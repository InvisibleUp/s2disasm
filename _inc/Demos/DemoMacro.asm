; macro to simplify editing the demo scripts
demoinput macro buttons,duration
btns_mask := 0
idx := 0
  rept strlen("buttons")
btn := substr("buttons",idx,1)
    switch btn
    case "U"
btns_mask := btns_mask|button_up_mask
    case "D"
btns_mask := btns_mask|button_down_mask
    case "L"
btns_mask := btns_mask|button_left_mask
    case "R"
btns_mask := btns_mask|button_right_mask
    case "A"
btns_mask := btns_mask|button_A_mask
    case "B"
btns_mask := btns_mask|button_B_mask
    case "C"
btns_mask := btns_mask|button_C_mask
    case "S"
btns_mask := btns_mask|button_start_mask
    endcase
idx := idx+1
  endm
	dc.b	btns_mask,duration-1
 endm