/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned rightCounter1 = input & 0b01010101010101010101010101010101;
	unsigned letfCounter1 = input & 0b10101010101010101010101010101010;
	unsigned counter1 = (letfCounter1 >> 1) + rightCounter1;
	unsigned rightCounter2 = counter1 & 0b00110011001100110011001100110011;
	unsigned leftCounter2 = counter1 & 0b11001100110011001100110011001100;
	unsigned counter2 = (leftCounter2 >> 2) + rightCounter2;
	unsigned rightCounter3 = counter2 & 0b00001111000011110000111100001111;
	unsigned leftCounter3 = counter2 & 0b11110000111100001111000011110000;
	unsigned counter3 = (leftCounter3 >> 4) + rightCounter3;
	unsigned rightCounter4 = counter3 & 0b00000000111111110000000011111111;
	unsigned leftCounter4 = counter3 & 0b11111111000000001111111100000000;
	unsigned counter4 = (leftCounter4 >> 8) + rightCounter4;
	unsigned rightCounter5 = counter4 & 0b00000000000000001111111111111111;
	unsigned leftCounter5 = counter4 & 0b11111111111111110000000000000000;
	unsigned counter5 = (leftCounter5 >> 16) + rightCounter5;
	return counter5;
}
