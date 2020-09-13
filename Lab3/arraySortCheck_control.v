
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;

	wire sGarbage, sStart, sNormal, sDone, sInversion;

	wire sGarbage_next = (sGarbage & ~go) | reset;
	wire sState_next = ((sGarbage & go) | (sStart & go) | (sDone & go) | (sInversion & go)) & ~reset;
	wire sNormal_next = ((sStart & ~zero_length_array & ~go) | (sNormal & ~end_of_array & ~inversion_found)) & ~reset;
	wire sInversion_next = ((sNormal & inversion_found) | (sInversion & ~go)) & ~reset;
	wire sDone_next = ((sNormal & end_of_array) | (sDone & ~go) | (sStart & zero_length_array & ~go)) & ~reset;

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStarte(sStart, sState_next, clock, 1'b1, 1'b0);
	dffe fsNormal(sNormal, sNormal_next, clock, 1'b1, 1'b0);
	dffe fsInversion(sInversion, sInversion_next, clock, 1'b1, 1'b0);
	dffe fsDone(sDone, sDone_next, clock, 1'b1, 1'b0);

	assign sorted = sDone;
	assign done = sDone | sInversion;
	assign load_input = sStart;
	assign load_index = sStart | sNormal;
	assign select_index = sNormal;


endmodule
