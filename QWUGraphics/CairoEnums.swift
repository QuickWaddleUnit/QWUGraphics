//
//  CairoEnums.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/12/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod

enum Content: UInt32 {
    case Color = 0x1000
    case Alpha = 0x2000
    case ColorAlpha = 0x3000
}

enum Format: Int32 {
    case Invalid    = -1
    case ARGB32
    case RGB24
    case A8
    case A1
    case RGB16_565
    case RGB30
}

enum Status: UInt32 {
    case Success = 0
    case NoMemory
    case InvalidRestore
    case InvalidPopGroup
    case NoCurrentPoint
    case InvalidMatrix
    case InvalidStatus
    case NullPtr
    case InvalidString
    case InvalidPathData
    case ReadError
    case WriteError
    case SurfaceFinished
    case SurfaceTypeMismatched
    case PatternTypeMismatched
    case InvalidContent
    case InvalidFormat
    case InvalidVisual
    case FileNotFound
    case InvalidDash
    case InvalidDSCComment
    case InvalidIndex
    case ClipNotRepresentable
    case TempFileError
    case InvalidStride
    case FontTypeMismatch
    case UserFontImmutable
    case UserFontError
    case NegativeCount
    case InvalidClusters
    case InvalidSlant
    case InvalidWeight
    case InvalidSize
    case UserFontNotImplemented
    case DeviceTypeMismatch
    case DeviceError
    case InvalidMeshConstruction
    case DeviceFinished
    case JBIG2GlobalMissing
    case LastStatus
}