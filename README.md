# Product-Hierarchy
SAP Product Hierarchy Report on SAP GUI, SAP Build App and IOS Devices
![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/7a5b1b8ac057f943a9ffa20f012656c01878424f/Images/Product-Hierarchy-SAP-GUI1-copy.jpg)

Product hierarchy refers to a systematic and hierarchical structure that categorize products based on their attributes, characteristics, and relationships within a company or industry. It involves organising products into different levels and categories, with each level providing increasing levels of detail and specification.

At the top level of the product hierarchy, you have broad product lines or groups that encompass a range of related products. As you move down the hierarchy, these product lines are further subdivided into categories, subcategories, and potentially even more granular levels.

The purpose of establishing a product hierarchy is to facilitate efficient product management, marketing, and decision-making processes within a company. It helps in organising and classifying products, understanding their relationships, and effectively managing product portfolios.

By having a well-defined product hierarchy, companies can analyse sales data, identify trends, and make informed decisions about product development, pricing, marketing strategies, and inventory management. It also aids in effective communication within the company and with external stakeholders, such as distributors and retailers, by providing a common language and structure for discussing products.

Product hierarchy maintenance in SAP involves organising products into a structured hierarchy based on a defined set of IDs. Each organisation may follow its own strategy for assigning and maintaining these IDs within the system. Consequently, when developing a custom report to display the product hierarchy, specific logic needs to be hardcoded based on the defined IDs in table T179 of transaction code O/76.

In this blog, I have devised a procedure to create a generic report that can display the product hierarchy regardless of the assigned IDs. This means that the report is adaptable and can accommodate different strategies used by organisations to maintain their product hierarchies.

Furthermore, I have explored the possibility of extending this report to SAP Build App and Frameworks used for developing Native iOS applications using the SAP Fiori iOS SDK. By leveraging the capabilities of SAP Fiori iOS SDK, the report can be transformed into a mobile application compatible with iOS devices. This allows users to conveniently access and view the product hierarchy on their iPhones or iPads, providing a seamless user experience and enhancing productivity.

By enhancing the report with SAP Fiori iOS SDK, users can benefit from features such as responsive design, intuitive navigation, and enhanced visualisations, all optimised for iOS devices. This empowers organisations to leverage their existing SAP infrastructure and deliver a mobile solution that meets the specific needs of their users, ensuring efficient and effective management of the product hierarchy on the go.

In summary, the blog introduces a procedure for developing a generic report to display product hierarchy in SAP, regardless of the maintained IDs. Additionally, it explores the potential of extending this report to an iOS application using SAP Fiori iOS SDK and SAP Build App, enabling users to access and interact with the product hierarchy on their Apple devices and other devices (using Browser).

## Product Hierarchy on SAP GUI

I have utilised the CL_GUI_SIMPLE_TREE class within the SAP GUI screen to present a comprehensive representation of the Product Hierarchy, which is stored in the T179 table.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-4.jpg)

Initially, the solution was designed to display the product hierarchy. However, it was later extended to include additional information such as the number of materials created. This extension can be further customised to include more details about the materials if needed.

To achieve this, a split container was used along with the CL_GUI_SIMPLE_TREE, CL_GUI_ALV_GRID, and CL_GUI_PICTURE classes. These classes were utilized to display all the relevant details. The program implemented the NODE_DOUBLE_CLICK and DOUBLE_CLICK events of the respective classes to enable interactive functionality.

The program output from the SAP GUI can be viewed in the provided video.

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://youtu.be/QrNF-QaUHE8)

In order to enhance the solution, the material images were also incorporated. These images were stored in the MIME Repository, specifically under the folder SAP–> PUBLIC –> (Custom Folder). Each material was associated with its respective material number.

Overall, the solution provided a visually appealing and informative display of the product hierarchy, including material details and images.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-5.jpg)

Initially, the solution aimed to display the product hierarchy and the material master details. However, it was enhanced by incorporating a custom option to upload material images. This customisation can be modified based on specific requirements. If the image upload option is not available in your system, you can modify the INIT_VIEW method as shown below, resulting in a solution limited to displaying the product hierarchy and created materials.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Screenshot-2023-05-23-at-8.26.14-PM.png)

## Created SAP OData Services:
A simple OData service was developed to retrieve Product Hierarchy details, which were then utilized to display the information in SAP Build and iOS apps. Throughout the development process, standard structures were used, ensuring no custom objects were created apart from the necessary classes and programs.

The OData project consisted of several entity types that mapped to specific structures, enabling the retrieval of Product Hierarchy data. These structures were implemented in the OData service to represent the relevant information accurately.

By utilising the OData service, the Product Hierarchy details were made accessible for integration with SAP Build and iOS apps. This allowed users to conveniently access and display the Product Hierarchy information within their respective applications.

The development approach focused on utilising standardised structures, ensuring compatibility and seamless integration with existing systems and technologies. The resulting OData service provided a reliable and efficient means of accessing and displaying Product Hierarchy details in SAP Build and iOS apps.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-8.jpg)
![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-10.jpg)

The OData service includes a set of redefined methods for each entity. These methods handle specific operations and interactions with the Product Hierarchy data. Here’s a more specific explanation of each method:

1. Heirarchyset_get_entity: This method retrieves either the parent product hierarchy or child node product hierarchy based on the availability of a filter.
2. Matbuildset_get_entityset: This method retrieves materials information based on a condition applied to the PRODUCT_ID field.
3. Matimgset_get_entity: This method retrieves material image details if the filter exists. Users can query for a specific material’s image details by applying a filter condition.
4. Matimgset_get_entityset: This method retrieves materials and their respective image details if a condition exists on the NAME field.
5. Matsinfoset_get_entityset: This method retrieves materials information if a condition exists on the PRDHA field. If a condition is specified, it retrieves materials that satisfy the given condition. Otherwise, it retrieves information about all product hierarchy parents.

By implementing these methods in the OData service, users have granular control over retrieving specific product hierarchy details, materials with their associated information, and material images. The methods enable efficient filtering and querying based on various criteria, enhancing the flexibility and usefulness of the OData service.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-12.jpg)
![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Screenshot-2023-05-23-at-8.26.57-PM.png)

##Product Hierarchy on SAP BUILD App
Before developing the application on SAP Build, I followed several steps and utilized the provided resources. Here’s a more specific description of the steps I took:

Installation of SAP Cloud Connector and System Setup:

The documentation guided me through the process of configuring the SAP Cloud Connector to establish a connection between my on-premises system and the SAP Build platform.

Configuration of SAP Build App in BTP:

The documentation helped me with the configuration process, ensuring the seamless integration of the SAP Build app within the BTP environment.

Destination Configuration for OData Service Access from SAP Build Apps:

To enable access to OData services from SAP Build apps, the configuration of destinations in BTP is crucial. This blog post provides a detailed explanation of the destination configuration required to establish a connection between the SAP Build apps and the developed OData service.

After completing the initial setup steps, which include installing SAP Cloud Connector, setting up the system, configuring SAP Build app in BTP, and defining destination settings for OData service access, the next step is to develop a new application on the SAP Build platform. The “Build an application” option offered by SAP Build is utilized to create the application, and then the desired functionality is built using the available tools and resources.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-14.jpg)

To display the Product Hierarchy and related materials details, the following pages were created:

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Screenshot-2023-05-23-at-8.27.34-PM.png)

Product Hierarchy       :

A Scrollable Basic List control was used to display the Product Name and the number of materials tagged to it. This page provided an overview of the product hierarchy structure.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-16.jpg)

Child Product Hierarchy:

Another Scrollable Basic List control was used to display the Child Product Name and the number of materials tagged to each child product. This page showed the child nodes of the selected parent product node, along with their associated materials.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-17.jpg)

Materials Information:

A Scrollable Image List control was used to display detailed information about materials. This included the Material Number, Description, and an image of each material. The displayed information was based on the selected parent Product Hierarchy node.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-18.jpg)

The application relied on specific data services to fetch the required details for display. These data services were integrated into the application to retrieve information about the product hierarchy, child products hierarchy, and materials details.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Screenshot-2023-05-23-at-8.28.04-PM.png)

Furthermore, an application variable was utilized across the pages to handle and display condition-based output. This variable enabled dynamic rendering of content based on user selections.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Screenshot-2023-05-23-at-8.28.29-PM.png)

To provide a visual demonstration of the developed application and its functionalities, a video was recorded, showcasing the various features and interactions available within the SAP Build platform.

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://youtu.be/pVIno0AOwuU)


By leveraging these pages, data services, application variables, and visual controls, the application developed in SAP Build presented a comprehensive view of the Product Hierarchy and its associated materials, empowering users to navigate and explore the information effectively.

 

###Development Steps:
To populate the “Product Hierarchy Parent Nodes” scrollable basic list on the initial loading of the application.

By connecting the HierarchySet service to the scrollable basic list, the application retrieved the necessary data to populate the list with parent product nodes.

The binding process established a connection between the service and the list, enabling the seamless retrieval and display of parent product data. This provided users with immediate access to the parent product nodes upon launching the application, facilitating easy navigation and exploration of the product hierarchy.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-22.jpg)

When selecting a cell on the Product Hierarchy page, logic performs a validation check to determine the content of the selected cell. Specifically, it checks if the selected cell contains any materials and also if it has any child product hierarchy nodes.

If the selected cell contains both materials and child product hierarchy nodes, a pop-up dialog box will be displayed, providing the user with a choice. The pop-up will prompt the user to select whether they want to view the materials associated with the selected product hierarchy or explore the child product hierarchy of the selected cell value.

In the scenario where only materials are found on the selected cell and there are no further child product hierarchies to explore, all the materials will be displayed in a comprehensive manner on the Materials Information page. This page will provide detailed information and attributes related to the materials, allowing users to access the necessary data.

Conversely, if the selected cell contains solely child product hierarchy nodes without any associated materials, the Child Product Hierarchy page will be displayed. This page will offer an in-depth view of the child product hierarchy, presenting all the relevant details and characteristics of each child node. Users will have the ability to explore and navigate through the child product hierarchy to gain a comprehensive understanding of the underlying structure and relationships.

By implementing this approach, I ensure that users are provided with the appropriate options and relevant information based on the content of the selected page, ultimately enhancing their experience and enabling efficient access to the desired data.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Screenshot-2023-05-23-at-8.29.16-PM.png)

If child product hierarchy condition is met, the system will display the Child Product Hierarchy page. This page utilizes the HierarcySet OData service to fetch the relevant details. However, there is an additional condition that needs to be considered: the SEL_KEY application variable, which holds the selected product hierarchy ID value.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-24.jpg)

The cell selection event logic flow of Child Product Hierarchy list is as follows:

When a cell is selected, the system checks if the selected product has any further hierarchy child products.

If there are child products available, the Child Product Hierarchy page’s data is refreshed to reflect the updated hierarchy.

If there are no child products, the system triggers an event to display the Materials Information page, which contains all the details related to the selected product hierarchy.

Alternatively, if there is a need for user input, a pop-up message appears, giving the option to choose between displaying further product hierarchy or materials details.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Screenshot-2023-05-23-at-8.30.55-PM.png)

When the condition to display materials is met, the system utilises the MatBuildSet OData service to retrieve the necessary data. This data is then presented on the Material Information page, which features a Scrollable Image List. The Scrollable Image List provides an intuitive interface for users to browse through the materials. Each material displayed in the list includes the following specific information:

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-26.jpg)

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-27.jpg)

The following code logic is used to display Base64-based image content in the respective area.

"data:image/"+ source.record.MimeType + ";base64," + REPLACE_ALL(REPLACE_ALL(source.record.ContentBase64, '_', '/'), '-', '+')

Image logic Referred from:

https://blogs.sap.com/2022/06/29/sap-appgyver-handling-image-loading-and-displaying-data/

##Product Hierarchy on IOS Devices
iOS devices are widely used for business data due to their robust security features, seamless integration with the Apple ecosystem, extensive availability of business-oriented apps, intuitive user experience, powerful device management capabilities, and expanding enterprise-focused features. These factors ensure secure data handling, streamlined workflows, and increased productivity for businesses relying on iOS devices.

SAP has been already The SAP Fiori iOS SDK. The SAP Fiori iOS SDK is utilised to develop native iOS applications that integrate with the SAP Fiori design system and SAP backend systems. It provides a set of pre-built UI controls, libraries, and tools that enable developers to create intuitive, consistent, and enterprise-grade iOS apps. The SDK offers features like offline support, authentication, data handling, and integration with SAP services, allowing businesses to deliver powerful and user-friendly mobile experiences tailored to their specific requirements. By leveraging the SAP Fiori iOS SDK, organisations can enhance productivity, drive innovation, and improve user satisfaction within their iOS application ecosystem.

I have expanded the product hierarchy development to IOS devices using SAP Fiori IOS SDK frameworks.

Followed the same process to display product hierarchy, which I have used in SAP BUILD App, however added few more features into it.

Refer below blog to how to use SAP Fiori IOS frameworks into XCode project:

https://blogs.sap.com/2020/08/03/hana-xsodata-consumption-in-xcode-project-using-sap-frameworks/

In Product Hierarchy application, I have developed a user interface using two views and one XIB (Xcode Interface Builder) file. The initial view is designed to display the parent product hierarchy, providing an overview of all the available product hierarchy parent node.

The main purpose of the first view is to allow users to explore the parent levels of the product hierarchy.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-29.jpg)

Function GETPARENT created to retrieve all parent product hierarchy details from the back-end SAP system. To accomplish this, utilised the heirarchySet OData service developed in back-end SAP system.

The GETPARENT function communicates with the OData service and retrieves the required data. The service returns a collection of parent product hierarchy objects, each containing relevant information such as product hierarchy names, IDs, and other properties.

Once the data is received from the OData service, it stores the parent hierarchy details in an array. This array is designed to hold the information for each parent product hierarchy in a structured format. Each element of the array corresponds to a specific parent hierarchy, and it contains the necessary attributes and values retrieved from the back-end system.

To enhance the user experience and provide easy navigation, swipe functionalities has been used into UITableControl. Users can swipe left or right on the screen to display the next or previously available product hierarchy related to the selected table cell.


![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-30.jpg)

By incorporating this approach, users can seamlessly navigate through the product hierarchy, explore parent and child hierarchies, and access detailed information about specific products. The swipe functionality adds a convenient way to move between different levels of the hierarchy, providing a fluid and intuitive user experience.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-31.jpg)

Also added double tap functionality on the table view cell. This feature allows users to double tap on a specific cell to display a pop-up view. The pop-up view provides basic information about the selected product, including materials, description, and an associated image retrieved from the back-end SAP system.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-32.jpg)
![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-33.jpg)

When a cell is double tapped, two functions are called: GETMATERIALSIMAGE and GETMATERIALSOFSELECTEDNODE. These functions are responsible for retrieving the required details from the back-end SAP system using the matimgSet and matsinfoSet OData services, respectively.

The GETMATERIALSIMAGE function communicates with the matimgSet service to fetch the image associated with the selected material. This function retrieves the image data from the back-end system and prepares it for display in the app.

Simultaneously, the GETMATERIALSOFSELECTEDNODE function interacts with the matsinfoSet service to retrieve additional information about the selected material, such as its description, attributes, and other relevant details.

After retrieving the required information, I have added the MATDETAILSVC XIB view, which is specifically designed to display the materials and their respective images in pop-up view format. This view is populated with the fetched data, including the material’s description, attributes, and the associated image.

By incorporating these functionalities, users can gain a basic understanding of the materials linked to the selected product hierarchy.

If there are multiple materials linked to the selected product hierarchy, a blue arrow icon is displayed within the pop-up view. This arrow icon serves as a navigation element, enabling users to move between different materials associated with the selected product. By tapping on the arrow icon, users can easily navigate to the next or previous materials, accessing their respective details.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-35.jpg)

Additionally, I have included a table icon above the pop-up view. This icon serves as an alternative option for users to view all the materials linked to the selected product hierarchy in a table format. Upon tapping the table icon, the view transitions to a table view that lists all the materials. This table view provides a comprehensive overview of all materials associated with the selected product, including their details and descriptions.

![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-36.jpg)

Modify below code logic from globalVariable Swift file to consider SAP Application Server and Port Number.

let oDataProvider = OnlineODataProvider(serviceName: "heirarchySet", serviceRoot: "http://{APPLICATION Server : PORT NUMBER}/sap/opu/odata/sap/ZMAT_HEIR_SRV/")

Also change below code logic from ViewController Swift file to maintain user id and password of SAP system, which is require to use OData service call.

oDataProvider.login(username: "SAP-USER-ID", password: "SAP_PASSWORD")

The following is a detailed overview of an iPhone app development project, tailored specifically to iPhone development:


![Alt text](https://github.com/ipravir/Product-Hierarchy/blob/a1c65eae00a4a1e07a951ca68ac0fc590db8a859/Images/Picture-1-37.jpg)

To effectively illustrate the capabilities and user experience of the developed iOS application, a comprehensive video demonstration was created.The recorded video presents a step-by-step showcase of the app’s distinct features and interactive functionalities, allowing viewers to gain a clear understanding of how the app works and how they can engage with its different components.


[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://youtu.be/WY1-qwLk-6I)

In this development, I have taken into account fundamental data regarding the product hierarchy and materials. However, it is important to note that this information can be expanded and tailored to align with the specific requirements of your organization.

Other important links:

[Configure Product Hierarchy in SAP Material Master (stechies.com)](https://www.stechies.com/product-hierarchy-sap-material-master/#:~:text=What%20is%20Product%20Hierarchy%3F,create%20Product%20Hierarchies%20in%20SAP.)

[Custom JavaScript (appgyver.com)](https://docs.appgyver.com/docs/custom-javascript)

GitHub link of Development objects : Product-Hierarchy

Happy Learning 🙂

Praveer Kumar Sen



