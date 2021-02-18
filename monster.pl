type(fire).
type(grass).
type(water).
type(electric).
type(normal).
/* All of the types as facts. */

monster(charmander, fire).
monster(bulbasaur, grass).
monster(squirtle, water).
monster(pikachu, electric).
monster(eevee, normal).
/* All of the monsters, and their types. */

ability(scratch, normal).
ability(tackle, normal).
ability(bodySlam, normal).
ability(bite, normal).
ability(lastResort, normal).
ability(fireFang, fire).
ability(firePunch, fire).
ability(sunnyDay, fire).
ability(thunderPunch, electric).
ability(thunderbolt, electric).
ability(vineWhip, grass).
ability(razorLeaf, grass).
ability(solarBeam, grass).
ability(grassKnot, grass).
ability(waterPulse, water).
ability(aquaTail, water).
ability(surf, water).
ability(rainDance, water).
/* All of the abilty names and their type. */

monsterAbility(charmander, scratch).
monsterAbility(charmander, fireFang).
monsterAbility(charmander, firePunch).
monsterAbility(charmander, thunderPunch).
monsterAbility(bulbasaur, tackle).
monsterAbility(bulbasaur, vineWhip).
monsterAbility(bulbasaur, razorLeaf).
monsterAbility(bulbasaur, solarBeam).
monsterAbility(squirtle, tackle).
monsterAbility(squirtle, waterPulse).
monsterAbility(squirtle, aquaTail).
monsterAbility(squirtle, bodySlam).
monsterAbility(pikachu, thunderPunch).
monsterAbility(pikachu, surf).
monsterAbility(pikachu, grassKnot).
monsterAbility(pikachu, thunderbolt).
monsterAbility(eevee, rainDance).
monsterAbility(eevee, sunnyDay).
monsterAbility(eevee, bite).
monsterAbility(eevee, lastResort).
/* What abilities every monster has at their disposal. */

typeEffectiveness(normal, fire, ordinary).
typeEffectiveness(normal, water, ordinary).
typeEffectiveness(normal, electric, ordinary).
typeEffectiveness(normal, grass, ordinary).
typeEffectiveness(normal, normal, ordinary).
typeEffectiveness(fire, fire, weak).
typeEffectiveness(fire, water, weak).
typeEffectiveness(fire, electric, ordinary).
typeEffectiveness(fire, grass, super).
typeEffectiveness(fire, normal, ordinary).
typeEffectiveness(water, fire, super).
typeEffectiveness(water, water, weak).
typeEffectiveness(water, electric, ordinary).
typeEffectiveness(water, grass, weak).
typeEffectiveness(water, normal, ordinary).
typeEffectiveness(electric, fire, ordinary).
typeEffectiveness(electric, water, super).
typeEffectiveness(electric, electric, weak).
typeEffectiveness(electric, grass, weak).
typeEffectiveness(electric, normal, ordinary).
typeEffectiveness(grass, fire, weak).
typeEffectiveness(grass, water, super).
typeEffectiveness(grass, electric, ordinary).
typeEffectiveness(grass, grass, weak).
typeEffectiveness(grass, normal, ordinary).
/* The effectiveness of the first against the second, so fire vs water = weak effectiveness */

abilityEffectiveness(A, M, E) :- ability(A, Y), monster(M, Z), typeEffectiveness(Y, Z, E).
/* If the ability A is of type Y, and the monster M is of type Z, and the type effectiveness 
of Y against Z is E, then the ability effectiveness of A against M is E.*/

superAbility(M1, A, M2) :- monster(M1, _), ability(A, Y), monsterAbility(M1, A), monster(M2, Z), typeEffectiveness(Y, Z, super).
/* If monster one has ability A, and uses ability A of type Y, on monster two of type Z, is Y super effective against Z?
Will return true or false. superAbility(bulbasaur, grassKnot, squirtle). would return false because bulbasaur does not have the ability. */

typeAbility(M, A) :- monster(M, X), ability(A, X), monsterAbility(M, A).
/* If Monster M of type X, and ability is of type X, and monster has that ability, then return true,
otherwise false. */ 

moreEffectiveSuper(A2, T, S) :- ability(A2, Y), typeEffectiveness(Y, T, S), not(S = weak), not(S = ordinary).
/* If the type of ability 2 'Y' is super effective against the type of monster 'T', then return S = super. If S is equal to weak or ordinary
 *  return false.*/
moreEffectiveWeak(A1, T, W) :- ability(A1, X), typeEffectiveness(X, T, W), not(W = super), not(W = ordinary).
/* If the type of ability 1 'X' is weak against the type of monster 'T', then return W = Weak. If W is equal to super or ordinary return false. */
moreEffectiveNotEqual(A1, A2, T) :- ability(A1, X), ability(A2, Y), typeEffectiveness(X, T, T1), typeEffectiveness(Y, T, T2), not(T1 == T2).
/* Take the type of ability 1 'X' and test its effectiveness against the type of monster 'T', do the same for ability 2. Then make sure the effectiveness 
 * of them against the type of monster is not the same.*/
moreEffectiveAbility(A1, A2, T) :- not(moreEffectiveSuper(A2, T, _)), not(moreEffectiveWeak(A1, T, _)), moreEffectiveNotEqual(A1, A2, T).
/* Takes two abilities A1 and A2, A2 cannot be super effective against type 'T' as super is the strongest and trumps all, A1 cannot be weak against 'T', 
 * as weak isn't stronger than anything, and finally the type effectiveness of A1 and A2 against 'T' cannot be equal because if A1 is ordinary, then A2 can either be weak,
 *  ordinary, or super, and we've covered super and weak, so if they are the same, neither are as effective.  */

counterAbilitySuper(A1, M2, S) :- monster(M2, Y), ability(A1, T1), typeEffectiveness(T1, Y, S), not(S = weak), not(S = ordinary).
/* Test the effectiveness of the type of ability A1, against the type of monster M2 'Y' and store the result in S.
 *  S cannot be weak or ordinary, as this is for when the ability used by monster 1 is super effective against monster 2. */
counterAbilityWeak(A2, M1, W) :- monster(M1, X), ability(A2, T2), typeEffectiveness(T2, X, W), not(W = super), not(W = ordinary).
/* Test the effectiveness of the type of ability being used by monster 2 against the type of monster 1, store result in W. W cannot be
 * super and it cannot be ordinary or this will fail. */
counterAbilityNotEqual(M2, A2, M1, A1) :- monster(M2, Y), monster(M1, X), ability(A2, T2), ability(A1, T1), typeEffectiveness(T2, X, R1), typeEffectiveness(T1, Y, R2), not(R1 == R2).
/* The type effectiveness of the ability used by monster 2 against monster 1 cannot be the same as the effectiveness of the ability used 
 * by monster 1 against monster 2. */
counterAbility(M1, A1, M2, A2) :- monsterAbility(M1, A1), monsterAbility(M2, A2), not(counterAbilitySuper(A1, M2, _)), not(counterAbilityWeak(A2, M1, _)), counterAbilityNotEqual(M2, A2, M1, A1).
/* Test that both monsters possess the abilities trying to be used respectively. Monster 1 cannot use an ability that is super effective against monster 2.
 * the ability used by monster 2 cannot be weak against monster 1. Lastly, the abilities used by each monster cannot produce the same effectiveness on
 *  the other monster, so they can't both be super effective, they cant both be ordinary effectiveness, and they both cant be weak. */