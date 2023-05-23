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

Product Hierarchy on SAP GUI

I have utilised the CL_GUI_SIMPLE_TREE class within the SAP GUI screen to present a comprehensive representation of the Product Hierarchy, which is stored in the T179 table.



