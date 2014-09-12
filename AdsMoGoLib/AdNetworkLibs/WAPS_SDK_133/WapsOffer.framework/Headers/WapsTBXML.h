#import <Foundation/Foundation.h>



typedef struct WapsTBXMLAttribute {
    char *name;
    char *value;
    struct WapsTBXMLAttribute *next;
} WapsTBXMLAttribute;

typedef struct WapsTBXMLElement {
    char *name;
    char *text;
    WapsTBXMLAttribute *firstAttribute;
    struct WapsTBXMLElement *parentElement;
    struct WapsTBXMLElement *firstChild;
    struct WapsTBXMLElement *currentChild;
    struct WapsTBXMLElement *nextSibling;
    struct WapsTBXMLElement *previousSibling;
} WapsTBXMLElement;

typedef struct WapsTBXMLElementBuffer {
    WapsTBXMLElement *elements;
    struct WapsTBXMLElementBuffer *next;
    struct WapsTBXMLElementBuffer *previous;
} WapsTBXMLElementBuffer;

typedef struct WapsTBXMLAttributeBuffer {
    WapsTBXMLAttribute *attributes;
    struct WapsTBXMLAttributeBuffer *next;
    struct WapsTBXMLAttributeBuffer *previous;
} WapsTBXMLAttributeBuffer;

@interface WapsTBXML : NSObject {

@private
    WapsTBXMLElement *rootXMLElement;
    WapsTBXMLElementBuffer *currentElementBuffer;
    WapsTBXMLAttributeBuffer *currentAttributeBuffer;
    long currentElement;
    long currentAttribute;
    char *bytes;
    long bytesLength;
}

@property(nonatomic, readonly) WapsTBXMLElement *rootXMLElement;


+ (id)tbxmlWithURL:(NSURL *)aURL;

+ (id)tbxmlWithXMLString:(NSString *)aXMLString;

+ (id)tbxmlWithXMLData:(NSData *)aData;

- (id)initWithURL:(NSURL *)aURL;

- (id)initWithXMLString:(NSString *)aXMLString;

- (id)initWithXMLData:(NSData *)aData;

@end

@interface WapsTBXML (StaticFunctions)

+ (NSString *)elementName:(WapsTBXMLElement *)aXMLElement;

+ (NSString *)textForElement:(WapsTBXMLElement *)aXMLElement;

+ (int)numberForElement:(WapsTBXMLElement *)aXMLElement;

+ (BOOL)boolForElement:(WapsTBXMLElement *)aXMLElement;

+ (int)negativeNumberForUnknownElement:(WapsTBXMLElement *)aXMLElement;

+ (NSString *)valueOfAttributeNamed:(NSString *)aName forElement:(WapsTBXMLElement *)aXMLElement;

+ (NSString *)attributeName:(WapsTBXMLAttribute *)aXMLAttribute;

+ (NSString *)attributeValue:(WapsTBXMLAttribute *)aXMLAttribute;

+ (WapsTBXMLElement *)nextSiblingNamed:(NSString *)aName searchFromElement:(WapsTBXMLElement *)aXMLElement;

+ (WapsTBXMLElement *)childElementNamed:(NSString *)aName parentElement:(WapsTBXMLElement *)aParentXMLElement;

@end
