//
//  EQDataManager.h
//  EQ
//
//  Created by Sebastian Borda on 4/30/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Cliente.h"
#import "Comunicacion.h"
#import "Pedido+extra.h"

#define PEDIDOS_FECHA_INICIO_IMPORTACION_KEY @"PEDIDOS_FECHA_INICIO_IMPORTACION_KEY"

#define VENTANA_SINCRONIZACION_EN_MINUTOS 15
#define NUMERO_DE_MESES_A_SINCRONIZAR 6

@interface EQDataManager : NSObject

@property (nonatomic,readonly) BOOL running; //Chequear si ya estamos sincronizando la aplicacion.

+ (EQDataManager *)sharedInstance;
- (void)updateDataShowLoading:(BOOL)show;
- (void)sendPendingData;
- (void)sendClient:(Cliente *)client
           success:(void (^)())success
           failure:(void (^)(NSError *error))failure;
- (int) getPendingOrders;
- (void)sendOrder: (Pedido *)order
          success: (void (^)())success
          failure: (void (^)(NSError *error))failure;
- (void)sendCommunication:(Comunicacion *)communication;

- (NSDate*) getLastSyncForCatalog;

- (void)updateCatalogSuccess:(void (^)())success
                     failure:(void (^)(NSError *error))failure;

- (void) checkIfArticlesDataNeedRefreshWithSuccess:(void (^)(BOOL needUpdate))success
                                           failure:(void (^)(NSError *error))failure;

- (void) updateProductsSuccess:(void (^)())success
                       failure:(void (^)(NSError *error))failure;

- (NSArray*) getProductsThatNeedToBeDownload;
- (NSArray*) getCatalogsImagesThatNeedToBeDownload;

- (void) downloadAllProductImages;
- (void) downloadAllCatalogImages;

- (void) downloadImageWithPath:(NSString*)imagePath
                      withName:(NSString*)fileName
                       isImage:(BOOL) isImage
                       success:(void (^)(UIImage *image))success
                       failure:(void (^)(NSError *error))failure;

- (void) resetUpdateCompleteForAllEntities;

@end
