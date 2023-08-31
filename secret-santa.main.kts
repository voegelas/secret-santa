#!/usr/bin/env kotlin

data class Person(val title: String, val familyName: String) {
    infix fun isRelatedTo(other: Person) = familyName == other.familyName

    override fun toString() = "$title $familyName"

    companion object {
        operator fun invoke(name: String): Person {
            val (title, familyName) = name.split(' ', limit = 2)
            return Person(title, familyName)
        }

        fun persons(names: List<String>) = names.map { Person(it) }
    }
}

data class MutablePair<T, R>(var first: T, var second: R) {
    fun toPair() = first to second
}

fun secretSanta(persons: List<Person>): List<Pair<Person, Person>> {
    // Assign random givers.
    val teams = persons.shuffled().zip(persons) { giver, receiver ->
        MutablePair(giver, receiver)
    }
    // Try to team persons with different family names.
    for (team in teams) {
        val (giver, receiver) = team
        if (giver isRelatedTo receiver) {
            val otherTeam = teams.find { (otherGiver, otherReceiver) ->
                // Find an unrelated giver.
                !(otherGiver isRelatedTo receiver || giver isRelatedTo otherReceiver)
            } ?: if (giver === receiver) {
                teams.find { (otherGiver) ->
                    // Find a relative.
                    otherGiver !== giver && otherGiver isRelatedTo giver
                } ?: break
            } else {
                break
            }
            // Swap the givers.
            with(otherTeam.first) {
                otherTeam.first = team.first
                team.first = this
            }
        }
    }
    return teams.map { it.toPair() }
}

val names = listOf(
    "Mr. Wall",
    "Mrs. Wall",
    "Mr. Anwar",
    "Mrs. Anwar",
    "Mr. Conway",
    "Mr. Cross",
)

for ((giver, receiver) in secretSanta(Person.persons(names))) {
    println("$giver -> $receiver")
}
