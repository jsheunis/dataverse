package edu.harvard.iq.dataverse.api;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.response.Response;
import java.util.logging.Logger;
import static javax.ws.rs.core.Response.Status.FORBIDDEN;
import static javax.ws.rs.core.Response.Status.OK;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertEquals;

public class SwordIT {

    private static final Logger logger = Logger.getLogger(SwordIT.class.getCanonicalName());
    private static String username1;
    private static String apiToken1;
    private static String dataverseAlias1;
    private static String datasetPersistentId1;

    @BeforeClass
    public static void setUpClass() {
        RestAssured.baseURI = UtilIT.getRestAssuredBaseUri();
    }

    @Test
    public void testCreateDatasetUploadFileDownloadFile() {

        Response createUser1 = UtilIT.createRandomUser();
//        createUser1.prettyPrint();
        username1 = UtilIT.getUsernameFromResponse(createUser1);
        apiToken1 = UtilIT.getApiTokenFromResponse(createUser1);

        Response createDataverse1Response = UtilIT.createRandomDataverse(apiToken1);
        createDataverse1Response.prettyPrint();
        dataverseAlias1 = UtilIT.getAliasFromResponse(createDataverse1Response);

        Response createDataset1Response = UtilIT.createRandomDatasetViaSwordApi(dataverseAlias1, apiToken1);
        createDataset1Response.prettyPrint();
        datasetPersistentId1 = UtilIT.getDatasetPersistentIdFromResponse(createDataset1Response);
        logger.info("persistent id: " + datasetPersistentId1);

        Response uploadFile1 = UtilIT.uploadRandomFile(datasetPersistentId1, apiToken1);
        uploadFile1.prettyPrint();

        Response swordStatement = UtilIT.getSwordStatement(datasetPersistentId1, apiToken1);
        swordStatement.prettyPrint();
        Integer fileId = UtilIT.getFileIdFromSwordStatementResponse(swordStatement);
        assertNotNull(fileId);
        assertEquals(Integer.class, fileId.getClass());

        logger.info("Id of uploaded file: " + fileId);
        String filename = UtilIT.getFilenameFromSwordStatementResponse(swordStatement);
        assertNotNull(filename);
        assertEquals(String.class, filename.getClass());
        /**
         * @todo Above we are using UtilIT.uploadRandomFile to upload a zip file
         * via SWORD but the zip file (trees.zip) is supposed to be unpacked and
         * the file within (trees.png) is supposed to be added to the dataset.
         *
         * What the line below indicates is that "trees.zip" is being uploaded
         * as-is and not unpacked:
         *
         * "Filename of uploaded file: trees.zip"
         */
        logger.info("Filename of uploaded file: " + filename);
        boolean uploadBugFixed = false;
        if (uploadBugFixed) {
            assertEquals("trees.png", filename);
        }

        Response attemptToDownloadUnpublishedFileWithoutApiToken = UtilIT.downloadFile(fileId);
        assertEquals(FORBIDDEN.getStatusCode(), attemptToDownloadUnpublishedFileWithoutApiToken.getStatusCode());

        Response downloadUnpublishedFileWithValidApiToken = UtilIT.downloadFile(fileId, apiToken1);
        assertEquals(OK.getStatusCode(), downloadUnpublishedFileWithValidApiToken.getStatusCode());
        logger.info("downloaded " + downloadUnpublishedFileWithValidApiToken.getContentType() + " (" + downloadUnpublishedFileWithValidApiToken.asByteArray().length + " bytes)");
    }

    @AfterClass
    public static void tearDownClass() {
        boolean disabled = false;

        if (disabled) {
            return;
        }

        Response deleteDatasetResponse = UtilIT.deleteDatasetViaSwordApi(datasetPersistentId1, apiToken1);
        deleteDatasetResponse.prettyPrint();
        assertEquals(204, deleteDatasetResponse.getStatusCode());

        Response deleteDataverse1Response = UtilIT.deleteDataverse(dataverseAlias1, apiToken1);
        deleteDataverse1Response.prettyPrint();
        assertEquals(200, deleteDataverse1Response.getStatusCode());

        Response deleteUser1Response = UtilIT.deleteUser(username1);
        deleteUser1Response.prettyPrint();
        assertEquals(200, deleteUser1Response.getStatusCode());

    }

}