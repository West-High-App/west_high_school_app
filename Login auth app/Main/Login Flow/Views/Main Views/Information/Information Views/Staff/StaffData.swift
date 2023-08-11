//
//  TeachersData.swift
//  West App
//
//  Created by Aiden Lee on 5/23/23.
//

import Foundation


struct teacher{
    let id = UUID()
    let teachername:String
    let email:String
    let phone:String
    let classes:[String]
    let aboutme:String
    let teacherphoto:String
}

struct teacherslist{
    static let allteacherslist = [
        teacher(teachername: "Nicholas Raykovich",
                email: "nykovich@madison.k12.wi.us",
                phone: "(608)-291-3499",
                classes: ["Algebra 1,", "Precalculus"],
                aboutme: "I have been teaching math for x amount of years, and love being at West! The students are amazing, especially Aiden Lee (he is my favorite).",
                teacherphoto:"pfp1"),
        teacher(teachername: "John Rademacher",
                email: "jrmacher@madison.k12.wi.us",
                phone: "(608)-495-1029",
                classes: ["Honors Biology"],
                aboutme: "I love Blackpink have a pet koala named Raskolnikov. I like traveling around and getting pictures with my koala and famous people.",
                teacherphoto:"pfp2"),
        teacher(teachername: "Michaela Kane",
                email: "mlkane@madison.k12.wi.us",
                phone: "(608)-911-6666",
                classes: ["Honors English 1,", "AP Literature"],
                aboutme: "I love shakespeare. My favorite book is Romeo and Juliet, and my favorite student of all time is August Andersen.",
                teacherphoto:"pfp3"),
        teacher(teachername: "Carrie Bohman",
                email: "cbohman@madison.k12.wi.us",
                phone: "(608)-124-4355",
                classes: ["US History Honors,", "World Issues"],
                aboutme: "I have taught at west for 27 years, and I love it. This place is full of history, right in the center of Madison, which is such a fantastic place to be and teach.",
                teacherphoto:"pfp4"),
        teacher(teachername: "Sigrid Murphy",
                email: "cbohman@madison.k12.wi.us",
                phone: "(608)-124-4355",
                classes: ["AP Calc AB", "AP Comp Sci"],
                aboutme: "Math is the language of the universe. Study it, learn it, understand it, and you will have the key to life.",
                teacherphoto:"pfp5"),
        teacher(teachername: "Jamie Riley",
                email: "jriley23@madison.k12.wi.us",
                phone: "(608)-124-4355",
                classes: ["Algebra, Pre-Calculus"],
                aboutme: "Madison is a fantastic place to teach. Coming from California, it's hot here, but it's nice. I love the students (especially August Andersen), which makes my job every day so much better.",
                teacherphoto:"pfp6"),
        teacher(teachername: "Austin Battaglia",
                email: "abattalgia@madison.k12.wi.us",
                phone: "(608)-241-2355",
                classes: ["Business, Social Media"],
                aboutme: "I love business, investing, and I used to work for Fetch Rewards!",
                teacherphoto:"pfp7"),
        teacher(teachername: "Lauren Cole",
                email: "lcole@madison.k12.wi.us",
                phone: "(608)-235-4355",
                classes: ["Marketing, Advertising"],
                aboutme: "I have a passion for advertising and social media. You should come to my classes! They are challenging but fun.",
                teacherphoto:"pfp8"),
        teacher(teachername: "Alex Byers",
                email: "albyers@madison.k12.wi.us",
                phone: "(608)-235-4355",
                classes: ["Spanish, AP Spanish"],
                aboutme: "I love speaking spanish and languages!",
                teacherphoto:"pfp9")
        ]
}
