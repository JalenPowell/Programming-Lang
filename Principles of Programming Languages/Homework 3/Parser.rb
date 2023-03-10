# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM-- > STMT +
# STMT-- > ASSIGN | "print"  EXP
# ASSIGN-- > ID  "="  EXP
# EXP-- > TERM   ETAIL
# ETAIL-- > "+" TERM   ETAIL | "-" TERM   ETAIL | EPSILON
# TERM-- > FACTOR  TTAIL
# TTAIL-- > "*" FACTOR TTAIL | "/" FACTOR TTAIL | EPSILON
# FACTOR-- > "(" EXP ")" | INT | ID
# ID-- > ALPHA +
# ALPHA-- > a | b | … | z or
#                  A | B | … | Z
# INT-- > DIGIT +
# DIGIT-- > 0 | 1 | … | 9
# WHITESPACE-- > Ruby Whitespace

#
#  Parser Class
#
load "Token.rb"
load "Lexer.rb"
class Parser < Scanner

	# Functions off using the fileand reads in the initial data
	def initialize(filename)
	super(filename)
	consume()
	end

	# Puts the tokens into the bufferand begins the process of reading themand going to the next token in the sequences
	def consume()
	@lookahead = nextToken()
	while (@lookahead.type == Token::WS)
		@lookahead = nextToken()
		end
		end

		# Makes sure that the type is matched with what is read in, otherwise it will count it as a parsing error
		# The input file will be regularly 'consumed' if everything is operating properly
		def match(dtype)
		if (@lookahead.type != dtype)
			puts "Expected #{dtype} found #{@lookahead.text}"
			@parseErrors = @parseErrors + 1
			end
			consume()
			end

			# First rule of the grammar that kicks off the initial process of the parsing
			# Clears the parsing errors to zero to ensure that the potential parse errors are counted correctly
			# PGM-- > STMT +
			def program()
			@parseErrors = 0
			while (@lookahead.type != Token::EOF)
				statement()
				end

				# This calculates the total number of parse errors that the program ends up calculating
				puts "There were #{@parseErrors} parse errors found."
				end

				# Simplified the rule by executing the second definition
				# STMT-- > ASSIGN | "print"  EXP
				def statement()
				puts "Entering STMT Rule"
				if (@lookahead.type == Token::PRINT)
					puts "Found PRINT Token: #{@lookahead.text}"
					match(Token::PRINT)
					exp()
				else
					assign()
					end

					puts "Exiting STMT Rule"
					end

					# EXP-- > TERM   ETAIL
					def exp()
					puts "Entering EXP Rule"
					term()
					etail()
					puts "Exiting EXP Rule"
					end

					# ASSIGN-- > ID  "="  EXP
					def assign()
					puts "Entering ASSGN Rule"
					id()
					if (@lookahead.type == Token::ASSGN)
						puts "Found ASSGN Token: #{@lookahead.text}"
						match(Token::ASSGN)
					else
						# This accounts for when the ASSGN is not found and a parser error occurs
						match(Token::ASSGN)
						end
						exp()
						puts "Exiting ASSGN Rule"
						end

						# TERM-- > FACTOR  TTAIL
						def term()
						puts "Entering TERM Rule"
						factor()
						ttail()
						puts "Exiting TERM Rule"
						end

						# ETAIL-- > "+" TERM   ETAIL | "-" TERM   ETAIL | EPSILON
						def etail()
						puts "Entering ETAIL Rule"
						if (@lookahead.type == Token::ADDOP)
							puts "Found ADDOP Token: #{@lookahead.text}"
							match(Token::ADDOP)
							term()
							etail()
							elsif(@lookahead.type == Token::SUBOP)
							puts "Found SUBOP Token: #{@lookahead.text}"
							match(Token::SUBOP)
							term()
							etail()
						else
							puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
							end
							puts "Exiting ETAIL Rule"
							end

							# ID-- > ALPHA +
							def id()
							if (@lookahead.type == Token::ID)
								puts "Found ID Token: #{@lookahead.text}"
								match(Token::ID)
							else
								# This accounts for when the ID is not found and a parser error occurs
								match(Token::ID)
								end
								end

								# FACTOR-- > "(" EXP ")" | INT | ID
								def factor()
								puts "Entering FACTOR Rule"
								if (@lookahead.type == Token::LPAREN)
									puts "Found LPAREN Token: #{@lookahead.text}"
									match(Token::LPAREN)
									exp()
									if (@lookahead.type == Token::RPAREN)
										puts "Found RPAREN Token: #{@lookahead.text}"
										match(Token::RPAREN)
									else
										# This accounts for when the RPAREN is not found and a parser error occurs
										match(Token::RPAREN)
										end
										elsif(@lookahead.type == Token::INT)
										int()
										elsif(@lookahead.type == Token::ID)
										id()
								else
									puts "Expected ( or INT or ID found #{@lookahead.type}"
									@parseErrors = @parseErrors + 1
									end
									puts "Exiting FACTOR Rule"
									end

									# INT-- > DIGIT +
									def int()
									if (@lookahead.type == Token::INT)
										puts "Found INT Token: #{@lookahead.text}"
										match(Token::INT)
									else
										# This accounts for when the INT is not found and a parser error occurs
										match(Token::INT)
										end
										end

										# TTAIL-- > "*" FACTOR TTAIL | "/" FACTOR TTAIL | EPSILON
										def ttail()
										puts "Entering TTAIL Rule"
										if (@lookahead.type == Token::MULTOP)
											puts "Found MULTOP Token: #{@lookahead.text}"
											match(Token::MULTOP)
											factor()
											ttail()
											elsif(@lookahead.type == Token::DIVOP)
											puts "Found DIVOP Token: #{@lookahead.text}"
											match(Token::DIVOP)
											factor()
											ttail()
										else
											puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
											end
											puts "Exiting TTAIL Rule"
											end
											end