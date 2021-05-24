//
//  Service.swift
//  PHYSID
//
//  Created by Apple on 23.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Credentials
struct CommentCredentials {
    
    let commentText: String
    
}

struct PostCredentials {
    
    let caption: String
    let title: String
    let postImageUrl: String?
    let isSay: Bool
    
    
}

struct FoodCredentials {
    
    let foodName: String
    let foodType: String
    let calories: Int
    let carbs: Int
    let proteins: Int
    let fats: Int
    let descriptiveInfo: String
    let foodImageUrl: String?
    let recipeVideoUrl: String?
    
}

struct WorkoutContentCredentials {
    
    let title: String
    let workoutContentType: String
    let assignedPurposalType: [String]
    let equipments: String
    let description: String
    let imageUrl: String?
    let instructionVideoUrl: String?
    let instructionDuration: String?
    
}

struct DietCredentials {
    
    var dietType: String?
    var dietDescriptiveBio: String
    var dietTitle: String
    var dietDefinitiveImageUrl: String?
    var isFree: Bool
    var minCalories: Int
    var maxCalories: Int
    var carbsPercentage: Int
    var proteinsPercentage: Int
    var fatsPercentage: Int

}


// MARK: - Properties

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)


struct Service {
    
    // MARK: - Saving & Uploading
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageDate = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageDate, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    static func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        let values = [
            "fullname": user.name!,
            "uid": user.uid as Any,
            "age": user.age as Any,
            "height": user.height as Any,
            "weight": user.weight as Any,
            "bmr": user.bmr as Any,
            "activity": user.activity as Any,
            "gender": user.gender as Any,
            "dietType": user.dietType as Any,
            "bodyGoalType": user.bodyGoalType as Any,
            "professionType": user.professionType as Any,
            "requiredCalories": user.requiredCalories as Any,
            "bio": user.bio,
            "location": user.location,
            "isProfessional": user.isProfessional,
            "profileImageUrl": user.profileImageUrl as Any,
            "backgroundImageUrl": user.backgroundImageUrl as Any,
            "isAdmin": user.isAdmin] as [String: Any]
        
        REF_USERS.child(user.uid).updateChildValues(values, withCompletionBlock: completion)
        
    }
    
    static func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    static func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    
    static func likePost(post: Post, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = post.didLike ? post.likes - 1 : post.likes + 1
        REF_POSTS.child(post.postID).child("likes").setValue(likes)
        
        if post.didLike {
            // unlike tweet
            REF_USER_LIKES.child(uid).child(post.postID).removeValue { (err, ref) in
                REF_POST_LIKES.child(post.postID).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet
            REF_USER_LIKES.child(uid).updateChildValues([post.postID: 1]) { (err, ref) in
                REF_POST_LIKES.child(post.postID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    
    static func saveFoodData(food: Food, completion: @escaping(DatabaseCompletion)) {
        let foodId = food.foodId
        let newFoodData = [
            "foodName": food.foodName,
            "calories": food.calories,
            "proteins": food.proteins,
            "fats": food.fats,
            "carbs": food.carbs,
            "foodDescriptiveBio": food.foodDescriptiveBio,
            "recipeVideoUrl": food.recipeVideoUrl ?? "",
            "foodType": food.foodTypeViewModel] as [String: Any]
        
        REF_FOODS.child(foodId).updateChildValues(newFoodData, withCompletionBlock: completion)
    }
    
    static func uploadFood(credentials: FoodCredentials, completion: @escaping(DatabaseCompletion)) {
        
        let foodId = NSUUID().uuidString
        let currentFoodData = [
            "foodId": foodId,
            "foodName": credentials.foodName,
            "calories": credentials.calories,
            "proteins": credentials.proteins,
            "fats": credentials.fats,
            "carbs": credentials.carbs,
            "foodDescriptiveBio": credentials.descriptiveInfo,
            "foodProfileImageUrl": credentials.foodImageUrl ?? "",
            "recipeVideoUrl": credentials.recipeVideoUrl ?? "",
            "foodType": credentials.foodType] as [String: Any]
        
        REF_FOODS.child(foodId).setValue(currentFoodData, withCompletionBlock: completion)
    }
    
    static func uploadWorkoutContent(credentials: WorkoutContentCredentials, completion: @escaping(DatabaseCompletion)) {
        
        let contentId = NSUUID().uuidString
        let currentContentData = [
            "contentId": contentId,
            "title": credentials.title,
            "workoutContentType": credentials.workoutContentType,
            "equipments": credentials.equipments,
            "description": credentials.description,
            "imageUrl": credentials.imageUrl ?? "",
            "instructionVideoUrl": credentials.instructionVideoUrl ?? "",
            "assignedPurposalType": credentials.assignedPurposalType,
            "instructionDuration": credentials.instructionDuration ?? ""] as [String: Any]
        
        REF_WORKOUT_CONTENTS.child(contentId).setValue(currentContentData, withCompletionBlock: completion)
    }
    
    static func uploadDiet(credentials: DietCredentials, completion: @escaping(DatabaseCompletion)) {
        
        let dietId = NSUUID().uuidString
        guard let ownerId = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(Date().timeIntervalSince1970)
        
        
        let dietData = [
            "dietId": dietId,
            "dietTitle": credentials.dietTitle,
            "creationDate": creationDate,
            "dietDescriptiveBio": credentials.dietDescriptiveBio,
            "dietDefinitiveImageUrl": credentials.dietDefinitiveImageUrl ?? "",
            "dietType": credentials.dietType as Any,
            "likes": 0,
            "comments": 0,
            "proteinsPercentage": credentials.proteinsPercentage,
            "carbsPercentage": credentials.carbsPercentage,
            "fatsPercentage": credentials.fatsPercentage,
            "minCalories": credentials.minCalories,
            "maxCalories": credentials.maxCalories,
            "ownerId": ownerId] as [String: Any]
        
        REF_DIETS.child(dietId).setValue(dietData) { (err, ref) in
            REF_USER_DIETS.child(ownerId).updateChildValues([dietId: 1], withCompletionBlock: completion)
        }
    }
    
    static func uploadDietFood(dietId: String,food: Food, category: String, day: String, completion: @escaping(DatabaseCompletion)) {
        let foodId = food.foodId
        REF_DIET_FOODS.child(dietId).child(category).child(day).updateChildValues([foodId: 1], withCompletionBlock: completion)
        
    }
    
    static func uploadMessage(_ message: String?,to user: User, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = user.uid else { return }
        let creationDate = Int(Date().timeIntervalSince1970)
        
        let values = ["text": message!,
                      "toId": uid,
                      "fromId": currentUid,
                      "creationDate": creationDate] as [String: Any]
        
        
        let messageRef = REF_MESSAGES.childByAutoId()
        guard let messageKey = messageRef.key else { return }
        print("message key is \(messageKey)")
        print("message ref is \(messageRef)")
        
        messageRef.updateChildValues(values)
        
        REF_USER_MESSAGES.child(currentUid).child(uid).updateChildValues([messageKey: 1])
        REF_USER_MESSAGES.child(uid).child(currentUid).updateChildValues([messageKey: 1])
        
    }
    
    static func uploadPost(credentials: PostCredentials, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = NSUUID().uuidString
        let creationDate = Int(Date().timeIntervalSince1970)
        
        let values = ["ownerUid": uid,
                      "timestamp": creationDate,
                      "likes": 0,
                      "comments": 0,
                      "caption": credentials.caption,
                      "postImageUrl": credentials.postImageUrl ?? "",
                      "postID": postId,
                      "isSay": credentials.isSay,
                      "title": credentials.title ] as [String : Any]
        
        
        REF_POSTS.child(postId).updateChildValues(values) { (err, postRef) in
            // update user-tweet structure after tweet upload completes
            REF_USER_POSTS.child(uid).updateChildValues([postId: 1], withCompletionBlock: completion)
        }
    }
    
    
    static func saveWorkoutContentData(workoutContent: WorkoutContent, completion: @escaping(DatabaseCompletion)) {
        let contentId = workoutContent.contentId
        let newContentData = [
            "title": workoutContent.title,
            "workoutContentType": workoutContent.workoutContenttype,
            "equipments": workoutContent.equipments,
            "description": workoutContent.description,
            "imageUrl": workoutContent.imageUrl ?? "",
            "instructionVideoUrl": workoutContent.instructionVideoUrl ?? "",
            "assignedPurposalType": workoutContent.assignedPurposalType,
            "instructionDuration": workoutContent.instructionDuration ?? ""] as [String: Any]
        
        REF_WORKOUT_CONTENTS.child(contentId).updateChildValues(newContentData, withCompletionBlock: completion)
    }
    
    static func removeWorkoutContent(workoutContent: WorkoutContent, completion: @escaping(DatabaseCompletion)) {
        let contentId = workoutContent.contentId
        REF_WORKOUT_CONTENTS.child(contentId).removeValue(completionBlock: completion)
    }
    
    static func removePost(post: Post, completion: @escaping(DatabaseCompletion)) {
        let postId = post.postID
        REF_POSTS.child(postId).removeValue(completionBlock: completion)
    }
    
    static func removeFood(food: Food, completion: @escaping(DatabaseCompletion)) {
        let foodId = food.foodId
        REF_FOODS.child(foodId).removeValue(completionBlock: completion)
    }
    
    static func uploadComment(credentials: CommentCredentials,post: Post, completion: @escaping(DatabaseCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let comments = (post.comments) + 1

        REF_POSTS.child(post.postID).child("comments").setValue(comments)

        
        let values = [
            "commentText": credentials.commentText,
            "creationDate": creationDate,
            "uid": uid] as [String: Any]
        
        REF_COMMENTS.child(post.postID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        
    }
    
    
    // MARK: - Fetching
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value else { return }
            let user = User(dictionary: dictionary as! [String : Any])
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    static func fetchFood(foodId: String, completion: @escaping(Food) -> Void) {
        REF_FOODS.child(foodId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let food = Food(foodId: foodId, dictionary: dictionary)
            completion(food)
        }
    }
    
    static func fetchFoods(completion: @escaping([Food]) -> Void) {
        var foods = [Food]()
        REF_FOODS.observe(.childAdded) { snapshot in
            let foodId = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let food = Food(foodId: foodId, dictionary: dictionary)
            foods.append(food)
            completion(foods)
        }
    }
    
    static func fetchDietFoods(category: String, day: String,completion: @escaping([Food]) -> Void) {
        var foods = [Food]()
        REF_DIET_FOODS.child(category).child(day).observe(.childAdded) { (snapshot) in
            let foodId = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let food = Food(foodId: foodId, dictionary: dictionary)
            foods.append(food)
            completion(foods)
        }
    }
    
    static func fetchDiets(completion: @escaping([Diet]) -> Void) {
        var diets = [Diet]()
        REF_DIETS.observe(.childAdded) { (snapshot) in
            let dietId = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let diet = Diet(dietId: dietId, dictionary: dictionary)
            diets.append(diet)
            completion(diets)
        }
    }

    static func fetchWorkoutContent(contentId: String, completion: @escaping(WorkoutContent) -> Void) {
        REF_WORKOUT_CONTENTS.child(contentId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let workoutContent = WorkoutContent(contentId: contentId, dictionary: dictionary)
            completion(workoutContent)
        }
    }
    
    static func fetchWorkoutContents(completion: @escaping([WorkoutContent]) -> Void) {
        var workoutContents = [WorkoutContent]()
        REF_WORKOUT_CONTENTS.observe(.childAdded) { (snapshot) in
            let contentId = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let workoutContent = WorkoutContent(contentId: contentId, dictionary: dictionary)
            workoutContents.append(workoutContent)
            completion(workoutContents)
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let query = REF_USER_MESSAGES.child(currentUid).child(user.uid).queryOrdered(byChild: "creationDate")
        
        query.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            
            REF_MESSAGES.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let message = Message(messageId: messageId, dictionary: dictionary)
                messages.append(message)
                completion(messages)
            }
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_MESSAGES.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let uid = snapshot.key
            
            REF_USER_MESSAGES.child(currentUid).child(uid).queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
                let messageId = snapshot.key
                print("message id is \(messageId)")
                REF_MESSAGES.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                    let message = Message(messageId: messageId, dictionary: dictionary)
                    
                    self.fetchUser(withUid: uid) { (user) in
                        let conversation = Conversation(user: user, message: message)
                        conversations.append(conversation)
                        completion(conversations)
                        print(conversations.count)
                    }
                }
            }
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        REF_POSTS.observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["ownerUid"] as? String else { return }
            fetchUser(withUid: uid) { (user) in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
            
        }
    }
    
    static func fetchPosts(forUser user: User, completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        REF_USER_POSTS.child(user.uid).queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            
            self.fetchPost(withPostID: postId) { (post) in
                posts.append(post)
                completion(posts)
            }
        }
        print("in service , amount of posts is said to be \(posts.count) ")
        
    }
    
    static func fetchPost(withPostID postID: String, completion: @escaping(Post) -> Void) {
        REF_POSTS.child(postID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            print("dictionary of post now is \(dictionary)")
            
            guard let uid = dictionary["ownerUid"] as? String else { return }
            
            print("uid of post now is \(uid)")
            
            Service.fetchUser(withUid: uid) { (user) in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                completion(post)
            }
            
        }
    }
    
    
    static func fetchLikes(forUser user: User, completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            self.fetchPost(withPostID: postID) { (likedPost) in
                var post = likedPost
                post.didLike = true
                
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    static func fetchComments(postId: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        
        REF_COMMENTS.child(postId).queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            self.fetchUser(withUid: uid) { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                comments.append(comment)
                completion(comments)
            }
        }
        
        
    }
    

    
    static func checkIfUserLikedPost(_ post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(post.postID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}





