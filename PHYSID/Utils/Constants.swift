//
//  Constants.swift
//  PHYSID
//
//  Created by Apple on 23.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_FOODS = DB_REF.child("foods")
let REF_WORKOUT_CONTENTS = DB_REF.child("workout-contents")
let REF_USER_FAV_WORKOUT_CONTENTS = DB_REF.child("user-favorite-workout-contents")
let REF_WORKOUT_CONTENT_FAVS = DB_REF.child("workout-content-favs")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_MESSAGES = DB_REF.child("messages")
let REF_USER_MESSAGES = DB_REF.child("user-messages")
let REF_USER_POSTS = DB_REF.child("user-posts")
let REF_POSTS = DB_REF.child("posts")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_POST_LIKES = DB_REF.child("post-likes")
let REF_COMMENTS = DB_REF.child("comments")
let REF_DIETS = DB_REF.child("diets")
let REF_USER_DIETS = DB_REF.child("user-diets")
let REF_DIET_FOODS = DB_REF.child("diet-foods")

