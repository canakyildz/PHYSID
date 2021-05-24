//
//  FoodCategoryViewModel.swift
//  PHYSID
//
//  Created by Apple on 5.04.2021.
//  Copyright © 2021 PHYSID. All rights reserved.
//

import Foundation

enum FoodCategoryViewModel: Int, CaseIterable {

    case PratikTarifler
    case GunlukEsansiyeller
    case Atistirmaliklar
    case KonserveGidalar
    case Corbalar
    case EtliYemekler
    case Dolmalar
    case Zeytinyaglilar
    case HamurIsleri
    case Ekmekler
    case Borekler
    case Pilavlar
    case Makarnalar
    case Tatlılar
    case Pastalar
    case Kekler
    case KurabiyelerBiskuviler
    case DenizUrunleri
    case Kahvaltılıklar
    case RecellerTursular
    case Icecekler
    case SalatalarMezeler
    case YoreselYemekler
    case DunyaMutfakları
    case MikrodalgaTarifleri
    
    var description: String {
        switch self {
        
        
        case .PratikTarifler:
            return "Pratik Tarifler"
        case .GunlukEsansiyeller:
            return "Günlük Temel İhtiyaçlar"
        case .Corbalar:
            return "Çorbalar"
        case .EtliYemekler:
            return "Etli Yemekler"
        case .Dolmalar:
            return "Dolmalar"
        case .Zeytinyaglilar:
            return "Zeytinyağlılar"
        case .HamurIsleri:
            return "HamurIsleri"
        case .Ekmekler:
            return "Ekmekler"
        case .Borekler:
            return "Borekler"
        case .Pilavlar:
            return "Pilavlar"
        case .Makarnalar:
            return "Makarnalar"
        case .Tatlılar:
            return "Tatlılar"
        case .Pastalar:
            return "Pastalar"
        case .Kekler:
            return "Kekler"
        case .KurabiyelerBiskuviler:
            return "Kurabiyeler Bisküviler"
        case .DenizUrunleri:
            return "Deniz Ürünleri"
        case .Kahvaltılıklar:
            return "Kahvaltılıklar"
        case .RecellerTursular:
            return "Reçeller Turşular"
        case .Icecekler:
            return "İçecekler"
        case .SalatalarMezeler:
            return "Salatalar Mezeler"
        case .YoreselYemekler:
            return "Yöresel Yemekler"
        case .DunyaMutfakları:
            return "Dünya Mutfakları"
        case .MikrodalgaTarifleri:
            return "Mikrodalga Tarifleri"
        case .Atistirmaliklar:
            return "Atıştırmalıklar"
        case .KonserveGidalar:
            return "Konserve Gıdalar"
        }
    }
//    init(index: Int) {
//        switch index {
//
//        case 0
//
//        }
//    }
}
