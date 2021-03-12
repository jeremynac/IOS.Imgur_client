//
//  MapImage.swift
//  Epicture
//
//  Created by Anthony Bellon on 21/10/2020.
//

import SwiftUI
import MapKit

struct MapImage: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 48.8231, longitude: 2.3382)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct MapImage_Previews: PreviewProvider {
    static var previews: some View {
        MapImage()
    }
}
