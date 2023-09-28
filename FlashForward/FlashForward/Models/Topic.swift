//
//  Topic.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

struct Topic: Identifiable, Equatable, Hashable {
    // topic details
    var id: UUID
    var name: String
    var emoji: String?
    var added: Bool
    
    // set details
    var total = 0
    
    private var _progress = 0
    var progress: Int {
        get { return _progress }
        set {
            if newValue > total {
                _progress = total
            } else if newValue < 0 {
                _progress = 0
            } else {
                _progress = newValue
            }
        }
    }

    var progressIndicatorValue: Double {
        if (total == 0){
            return 0
        } else {
            return Double(progress) / Double(total)
        }
    }
    
    var flashCards: [TopicItem]
    var mostRecentFlashCard: UUID
    var shuffled: Bool

    
    init(name: String, emoji: String? = nil, makeFlashCards: Bool = false){
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.added = makeFlashCards ? true : false
        self.flashCards = []
        self.mostRecentFlashCard = self.id
        self.shuffled = false
        
        if makeFlashCards { self.makeFlashCards() }
    }
    
    // TODO: REMOVE WHEN DONE
    mutating func makeFlashCards() {
        let myDictionaries =
            [Dictionary(word: "yay", definitions:
                      [Definition(definition: "yay definition 1", example: "yay example 1"),
                       Definition(definition: "yay definition 2", example: nil)]),
            Dictionary(word: "success", definitions:
                      [Definition(definition: "success definition 1", example: "success example 1"),
                       Definition(definition: "success definition 2", example: "success example 2")]),
            Dictionary(word: "annoying", definitions:
                      [Definition(definition: "annoying definition 1", example: nil),
                       Definition(definition: "annoying definition 2", example: "annoying example 2")])
        ]
        for d in myDictionaries {
            addFlashCard(dictionary: d)
        }
    }
    
    mutating func incrementProgress(){
        self.progress += 1
    }
    
    mutating func markCardAsViewed(_ card: TopicItem) {
        if let index = flashCards.firstIndex(where: { $0.id == card.id }){
            if !flashCards[index].viewed {
                flashCards[index].viewed = true
                progress += 1
            }
        }
    }
    
    mutating func addToLearning(dictionaries: [Dictionary]){
        self.added = true
        for d in dictionaries {
            addFlashCard(dictionary: d)
        }
    }
    
    mutating func removeFromLearning(){
        self.added = false
        deleteFlashCards()
    }
    
    mutating func addFlashCard(dictionary: Dictionary) {
        var orderIndexArray = self.flashCards.map { $0.orderIndex }
        var orderIndex = orderIndexArray.max() ?? 0
        self.flashCards.append(TopicItem(dictionary: dictionary, order: orderIndex))
        self.total += 1
    }
    
    mutating func removeFlashCard() {
       // TODO: write removeFlashCard()
    }
    
    mutating func deleteFlashCards(){
        flashCards = []
        progress = 0
        total = 0
    }
    
    static func ==(lhs: Topic, rhs: Topic) -> Bool{
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

let catTypes = ["Domestic Shorthair", "Maine Coon", "Siamese", "Persian", "Bengal", "Ragdoll", "Sphynx", "Scottish Fold", "Abyssinian", "Burmese", "Russian Blue", "British Shorthair", "Savannah", "Manx", "Himalayan", "Turkish Van", "Cornish Rex", "American Shorthair", "Norwegian Forest Cat", "Egyptian Mau", "Oriental Shorthair", "Balinese", "Birman", "Chartreux", "Devon Rex", "Exotic Shorthair", "Japanese Bobtail", "Korat", "LaPerm", "Munchkin", "Ocicat", "Peterbald", "Pixiebob", "Selkirk Rex", "Singapura", "Somali", "Tonkinese", "Toyger", "Ukrainian Levkoy", "American Curl", "Australian Mist", "Chausie", "Cheetoh", "Donskoy", "Khao Manee", "Nebelung", "Serengeti"]

let birdTypes = ["Sparrow", "Eagle", "Hummingbird", "Robin", "Falcon", "Blue Jay", "Owl", "Penguin", "Toucan", "Pelican", "Flamingo", "Crow", "Parrot", "Woodpecker", "Swan", "Pigeon", "Seagull", "Peacock", "Canary", "Heron", "Dove", "Cardinal", "Albatross", "Finch", "Gull", "Kingfisher", "Magpie", "Puffin", "Raven", "Warbler", "Wren", "Osprey", "Vulture", "Spoonbill", "Cockatoo", "Gannet", "Sparrowhawk", "Cuckoo", "Kookaburra", "Harrier", "Tern", "Cormorant", "Egret", "Bee-eater", "Jacana", "Shrike", "Stork", "Quail"]

let countries = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "North Macedonia", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States of America", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"]

let flags = ["Afghanistan Flag", "Albania Flag", "Algeria Flag", "Andorra Flag", "Angola Flag", "Antigua and Barbuda Flag", "Argentina Flag", "Armenia Flag", "Australia Flag", "Austria Flag", "Azerbaijan Flag", "Bahamas Flag", "Bahrain Flag", "Bangladesh Flag", "Barbados Flag", "Belarus Flag", "Belgium Flag", "Belize Flag", "Benin Flag", "Bhutan Flag", "Bolivia Flag", "Bosnia and Herzegovina Flag", "Botswana Flag", "Brazil Flag", "Brunei Flag", "Bulgaria Flag", "Burkina Faso Flag", "Burundi Flag", "Cabo Verde Flag", "Cambodia Flag", "Cameroon Flag", "Canada Flag", "Central African Republic Flag", "Chad Flag", "Chile Flag", "China Flag", "Colombia Flag", "Comoros Flag", "Congo Flag", "Costa Rica Flag", "Croatia Flag", "Cuba Flag", "Cyprus Flag", "Czech Republic Flag", "Democratic Republic of the Congo Flag", "Denmark Flag", "Djibouti Flag", "Dominica Flag", "Dominican Republic Flag", "Ecuador Flag", "Egypt Flag", "El Salvador Flag", "Equatorial Guinea Flag", "Eritrea Flag", "Estonia Flag", "Eswatini Flag", "Ethiopia Flag", "Fiji Flag", "Finland Flag", "France Flag", "Gabon Flag", "Gambia Flag", "Georgia Flag", "Germany Flag", "Ghana Flag", "Greece Flag", "Grenada Flag", "Guatemala Flag", "Guinea Flag", "Guinea-Bissau Flag", "Guyana Flag", "Haiti Flag", "Honduras Flag", "Hungary Flag", "Iceland Flag", "India Flag", "Indonesia Flag", "Iran Flag", "Iraq Flag", "Ireland Flag", "Israel Flag", "Italy Flag", "Ivory Coast Flag", "Jamaica Flag", "Japan Flag", "Jordan Flag", "Kazakhstan Flag", "Kenya Flag", "Kiribati Flag", "Kosovo Flag", "Kuwait Flag", "Kyrgyzstan Flag", "Laos Flag", "Latvia Flag", "Lebanon Flag", "Lesotho Flag", "Liberia Flag", "Libya Flag", "Liechtenstein Flag", "Lithuania Flag", "Luxembourg Flag", "Madagascar Flag", "Malawi Flag", "Malaysia Flag", "Maldives Flag", "Mali Flag", "Malta Flag", "Marshall Islands Flag", "Mauritania Flag", "Mauritius Flag", "Mexico Flag", "Micronesia Flag", "Moldova Flag", "Monaco Flag", "Mongolia Flag", "Montenegro Flag", "Morocco Flag", "Mozambique Flag", "Myanmar Flag", "Namibia Flag", "Nauru Flag", "Nepal Flag", "Netherlands Flag", "New Zealand Flag", "Nicaragua Flag", "Niger Flag", "Nigeria Flag", "North Korea Flag", "North Macedonia Flag", "Norway Flag", "Oman Flag", "Pakistan Flag", "Palau Flag", "Palestine Flag", "Panama Flag", "Papua New Guinea Flag", "Paraguay Flag", "Peru Flag", "Philippines Flag", "Poland Flag", "Portugal Flag", "Qatar Flag", "Romania Flag", "Russia Flag", "Rwanda Flag", "Saint Kitts and Nevis Flag", "Saint Lucia Flag", "Saint Vincent and the Grenadines Flag", "Samoa Flag", "San Marino Flag", "Sao Tome and Principe Flag", "Saudi Arabia Flag", "Senegal Flag", "Serbia Flag", "Seychelles Flag", "Sierra Leone Flag", "Singapore Flag", "Slovakia Flag", "Slovenia Flag", "Solomon Islands Flag", "Somalia Flag", "South Africa Flag", "South Korea Flag", "South Sudan Flag", "Spain Flag", "Sri Lanka Flag", "Sudan Flag", "Suriname Flag", "Sweden Flag", "Switzerland Flag", "Syria Flag", "Taiwan Flag", "Tajikistan Flag", "Tanzania Flag", "Thailand Flag", "Timor-Leste Flag", "Togo Flag", "Tonga Flag", "Trinidad and Tobago Flag", "Tunisia Flag", "Turkey Flag", "Turkmenistan Flag", "Tuvalu Flag", "Uganda Flag", "Ukraine Flag", "United Arab Emirates Flag", "United Kingdom Flag", "United States of America Flag", "Uruguay Flag", "Uzbekistan Flag", "Vanuatu Flag", "Vatican City Flag", "Venezuela Flag", "Vietnam Flag", "Yemen Flag", "Zambia Flag", "Zimbabwe Flag"]

let flowers = ["Rose", "Tulip", "Sunflower", "Lily", "Daisy", "Peony", "Carnation", "Orchid", "Hyacinth", "Daffodil", "Marigold", "Chrysanthemum", "Hibiscus", "Lavender", "Iris", "Gerbera", "Pansy", "Anemone", "Zinnia", "Crocus", "Snapdragon", "Foxglove", "Cosmos", "Begonia", "Aster", "Petunia", "Freesia", "Gladiolus", "Morning Glory", "Cherry Blossom", "Poppy", "Lotus", "Columbine", "Lilac", "Primrose", "Ranunculus", "Amaryllis", "Bleeding Heart", "Tiger Lily", "Sweet Pea", "Tansy", "Clematis", "Borage", "Fuchsia", "Poinsettia", "Bougainvillea", "Dahlia", "Lantana", "Wisteria", "Gazania"]

//var topicList = [Topic(name: "Birds"), Topic(name: "Cats"), Topic(name: "Countries"), Topic(name: "Flowers")]
