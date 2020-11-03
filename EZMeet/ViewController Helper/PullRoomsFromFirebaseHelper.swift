//
//  PullRoomsFromFirebaseHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/30/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import Firebase

extension ViewController {
    func getJoinedRoomsFromFirebase() {
        var keyOfJoinedRooms = [String]()
        
        //Get list of keys of joined rooms
        ref = Database.database().reference()
        let roomsRef = ref.child("users").child(user.uid).child("rooms")
        roomsRef.observe(.value, with: { (snapshot) in
            keyOfJoinedRooms = []
            print(snapshot.childrenCount)
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                print(child.key)
                keyOfJoinedRooms += [child.key]
            }
            print(keyOfJoinedRooms)
            self.getRoomsInfo(keyOfJoinedRooms: keyOfJoinedRooms)
        })
    }
    
    /*
    func getRoomsInfo(keyOfJoinedRooms: [String]) {
        //Clear all rooms which saved locally
        self.rooms = []
        
        var votersInRoom = [String]()
        
        //Prepare to get room
        ref = Database.database().reference()
        let roomsRef = ref.child("rooms")
        roomsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if keyOfJoinedRooms.contains(child.key) {
                    votersInRoom = []

                    print("\n\n\n\n\n\n\(child.key)")
                    let value = child.value as? NSDictionary
                    let adminKey = value?["admin"] as? String ?? ""
                    let isPrivate = value?["isPrivate"] as! Bool
                    let notes = value?["notes"] as? String ?? ""
                    let title = value?["title"] as? String ?? ""
                    let type = value?["type"] as? String ?? ""
                    
                    let voters = value?["voters"] as? NSDictionary
                    print("voters: ", voters)
                    
                    for (id, _) in voters! {
                        votersInRoom += [id as? String ?? ""]
                        print("sfajkhkfk", votersInRoom)
                    }
                    
                    let meetLocation = value?["meetLocation"] as? NSDictionary
                    let inString = meetLocation?["inString"] as? String ?? ""
                    let lat = meetLocation?["lat"] as? Double ?? 0
                    let lng = meetLocation?["lng"] as? Double ?? 0
                    
                    print(adminKey)
                    print(isPrivate)
                    print(notes)
                    print(title)
                    print(votersInRoom)
                    print(inString)
                    print(lat)
                    print(lng)
                    
                    var userWhoVoteInThisRoom = [Voter]()
                    
                    ref = Database.database().reference()
                    let usersRef = ref.child("users")
                    print(votersInRoom.count)
                    usersRef.observeSingleEvent(of: .value, with: { (miniSnapshot) in
                        for child in miniSnapshot.children.allObjects as! [DataSnapshot] {
                            print(child.key)
                            if votersInRoom.contains(child.key) {
                                let value = child.value as? NSDictionary
                                let email = value?["email"] as? String ?? ""
                                let name = value?["name"] as? String ?? ""
                                let homeLocation = value?["homeLocation"] as? NSDictionary
                                let inString = homeLocation?["inString"] as? String ?? ""
                                let lat = homeLocation?["lat"] as? Double ?? 0
                                let lng = homeLocation?["lng"] as? Double ?? 0
                                
                                print("\n\n\n\n\n\n\n\n\n\n")
                                print(email)
                                print(name)
                                print(inString)
                                print(lat)
                                print(lng)
                                
                                let location = Location(inString: inString, lat: lat, lng: lng)!
                                let user = Voter(avatar: #imageLiteral(resourceName: "demoAvatar"), name: name, homeLocation: location, email: email, uid: child.key)!
                                userWhoVoteInThisRoom += [user]
                            }
                        }
                        
                        //After done getting all userWhoVoteInThisRoom value
                        
                        var admin: Voter!
                        //Because admin is also a voter, get admin profile from the voters' profiles
                        for user in userWhoVoteInThisRoom {
                            print(user.uid)
                            print(adminKey)
                            if user.uid == adminKey {
                                admin = user
                            }
                        }
                        
                        //Find admin info
                        ref = Database.database().reference()
                        let userRef = ref.child("users")
                        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            for child in snapshot.children.allObjects as! [DataSnapshot] {
                                print(child.key)
                                print(adminKey)
                                if child.key == adminKey {
                                    let value = child.value as? NSDictionary

                                    let email = value?["email"] as? String ?? ""
                                    let name = value?["name"] as? String ?? ""
                                    let homeLocation = value?["homeLocation"] as? NSDictionary
                                    let inString = homeLocation?["inString"] as? String ?? ""
                                    let lat = homeLocation?["lat"] as? Double ?? 0
                                    let lng = homeLocation?["lng"] as? Double ?? 0
                                    
                                    print("\n\n\n\n\n\n\n\n\n\n")
                                    print("asdaf")
                                    print(email)
                                    print(name)
                                    print(inString)
                                    print(lat)
                                    print(lng)
                                    
                                    let location = Location(inString: inString, lat: lat, lng: lng)!
                                    
                                    admin = Voter(avatar: #imageLiteral(resourceName: "demoAvatar"), name: name, homeLocation: location, email: email, uid: adminKey)
                                    
                                    break
                                }
                            }
                            
                            
                            let location = Location(inString: inString, lat: lat, lng: lng)!
                            print(userWhoVoteInThisRoom.count)
                            self.rooms += [Room(title: title, admin: admin!, voters: userWhoVoteInThisRoom, meetLocation: location, notes: notes, type: type, isPrivate: isPrivate, uuid: child.key)!]
                            
                            userWhoVoteInThisRoom = []

                            print("number of rooms: ", self.rooms.count)
                            
                            print(self.rooms.count)
                            print(keyOfJoinedRooms.count)
                            //Update once only there's full data
                            if self.rooms.count == keyOfJoinedRooms.count {
                                DispatchQueue.main.async {
                                    self.pollTableView.reloadData()
                                }
                            }
                        })
                    })
                }
            }
        })
    }*/
    

    func getRoomsInfo(keyOfJoinedRooms: [String]) {
        //Clear all rooms which saved locally
        self.rooms.removeAll()
        
        print(self.rooms.count)
        
        var votersInRoom = [String]()
        //Prepare to get room
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (rootSnapshot) in
            if let roomsRef = rootSnapshot.children.allObjects[0] as? DataSnapshot {
                for room in roomsRef.children.allObjects as! [DataSnapshot] {
                    if keyOfJoinedRooms.contains(room.key) {
                        votersInRoom = []

                        let value = room.value as? NSDictionary
                        let adminKey = value?["admin"] as? String ?? ""
                        let isPrivate = value?["isPrivate"] as! Bool
                        let notes = value?["notes"] as? String ?? ""
                        let title = value?["title"] as? String ?? ""
                        let type = value?["type"] as? String ?? ""
                        let lastActivity = value?["lastActivity"] as? Int
                        
                        let voters = value?["voters"] as? NSDictionary
                        
                        for (id, _) in voters! {
                            votersInRoom += [id as? String ?? ""]
                        }
                        
                        let meetLocation = value?["meetLocation"] as? NSDictionary
                        let inString = meetLocation?["inString"] as? String ?? ""
                        let lat = meetLocation?["lat"] as? Double ?? 0
                        let lng = meetLocation?["lng"] as? Double ?? 0
                        
                        print(adminKey)
                        print(isPrivate)
                        print(notes)
                        print(title)
                        print(votersInRoom)
                        print(inString)
                        print(lat)
                        print(lng)
                        
                        var userWhoJoinInThisRoom = [Voter]()
                        var admin: Voter!
                        
                        if let usersRef = rootSnapshot.children.allObjects[1] as? DataSnapshot {
                            for user in usersRef.children.allObjects as! [DataSnapshot] {
                                if votersInRoom.contains(user.key) {
                                    let value = user.value as? NSDictionary
                                    let email = value?["email"] as? String ?? ""
                                    let name = value?["name"] as? String ?? ""
                                    let homeLocation = value?["homeLocation"] as? NSDictionary
                                    let inString = homeLocation?["inString"] as? String ?? ""
                                    let lat = homeLocation?["lat"] as? Double ?? 0
                                    let lng = homeLocation?["lng"] as? Double ?? 0
                                    let avaURL = value?["avaURL"] as? String ?? ""
                                    
                                    /*
                                    print(email)
                                    print(name)
                                    print(inString)
                                    print(lat)
                                    print(lng)
                                    print(avaURL)*/
                                    
                                    let location = Location(inString: inString, lat: lat, lng: lng)!
                                    let joinedUser = Voter(avaURL: avaURL, name: name, homeLocation: location, email: email, uid: user.key)!
                                    userWhoJoinInThisRoom += [joinedUser]
                                    userWhoJoinInThisRoom = Array(Set(userWhoJoinInThisRoom))
                                    
                                    //Add admin too
                                    if user.key == adminKey {
                                        admin = joinedUser
                                    }
                                }
                            }
                            
                            //Done getting all data, prepare to load
                            let location = Location(inString: inString, lat: lat, lng: lng)!
                            print(userWhoJoinInThisRoom.count)
                            
                            
                            if self.rooms.count > keyOfJoinedRooms.count - 1 {
                                self.rooms.removeAll()
                            }
                            
                            let newRoom = Room(title: title, admin: admin!, voters: userWhoJoinInThisRoom, meetLocation: location, notes: notes, type: type, isPrivate: isPrivate, uuid: room.key, latestActivity: lastActivity!)!
                            
                            if !self.rooms.contains(newRoom) {
                                self.rooms += [newRoom]
                            }
                            
                            userWhoJoinInThisRoom = []
                            
                            print("number of rooms: ", self.rooms.count)
                            
                            if self.rooms.count == 0 {
                                self.stateMachine.transitionToState(.view("empty"), animated: true) {
                                    print("finished switching to empty view")
                                }
                            }
                            
                            print(self.rooms.count)
                            print(keyOfJoinedRooms.count)
                            
                            //Update once only there's full data
                            if self.rooms.count == keyOfJoinedRooms.count {
                                DispatchQueue.main.async {
                                    
                                    //self.getJoinedRoomsFromFirebase()
                                    
                                    self.pollTableView.reloadData()
                                    
                                    //self.endOfWork()
                                    
                                    self.saveRooms()
                                    
                                    self.endLoading(error: nil, completion: {
                                        print("completion endLoading -> loadingState: \(self.currentState.rawValue)")
                                    })
                                    print("endLoading -> loadingState: \(self.lastState.rawValue)")
                                    
                                    //self.refreshControl.endRefreshing()
                                }
                            }
                        }
                    }
                }
                if self.rooms.count == 0 || self.rooms.isEmpty {
                    self.stateMachine.transitionToState(.view("empty"), animated: true) {
                        print("finished switching to empty view")
                    }
                    self.endLoading()
                }
            }
            else {
                if self.rooms.count == 0 || self.rooms.isEmpty {
                    self.stateMachine.transitionToState(.view("empty"), animated: true) {
                        print("finished switching to empty view")
                    }
                    self.endLoading()
                }
            }
        })
    }
}

extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}

struct Post : Hashable {
    var id : Int
    var hashValue : Int { return self.id }
}

func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.id == rhs.id
}

