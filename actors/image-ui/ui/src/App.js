import { ChakraProvider, Grid, Button, Flex, Table, Tbody, Td, Th, Thead, Tr, VStack, Box, Image, Heading, Select, Input } from "@chakra-ui/react";
import { ColorModeSwitcher } from "./ColorModeSwitcher";
import React, { useState } from "react";

function App() {
  const [model, setModel] = useState("mobilenetv27");
  const [priority, setPriority] = useState("accuracy");
  const [results, setResults] = useState([]);
  const [runTime, setRunTime] = useState("");
  const [imageSrc, setImageSrc] = useState("");

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        setImageSrc(e.target.result);
      };
      reader.readAsDataURL(file);
      processImage(file);
    }
  };

  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  const lookup = new Uint8Array(256);

  for (let i = 0; i < chars.length; i++) {
    lookup[chars.charCodeAt(i)] = i;
  }

  const processImage = (buffer) => {
    let startTime = new Date();
    let modelId = model || "default";

    if (!modelId || modelId === "default") {
      modelId = priority || "default";
    }

    console.log("Setting up fetch request");

    fetch('/' + modelId + '/matches', {
      method: 'PUT',
      headers: {
        "Content-Type": "application/octet-stream"
      },
      body: buffer,
    })
      .then(response => {
        if (!response.ok) {
          console.dir(response);
          throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
      })
      .then(data => {
        let outputData = data.filter(item => item.probability >= 0.01);
        printElapsed(startTime);
        setResults(outputData);
      })
      .catch(error => {
        console.error('Error occurred:', error);
      });
  };

  const printElapsed = (startTime) => {
    let endTime = new Date();
    let timeDiff = endTime - startTime;
    timeDiff /= 1000;
    let timeElapsed = timeDiff;
    console.log("elapsed time = ", timeElapsed, "sec");
    setRunTime(`Elapsed time: ${timeElapsed} sec`);
    return timeElapsed;
  };

  return (
    <ChakraProvider>
      <ColorModeSwitcher />
      <Box margin="0 auto" maxWidth="1200px" pt="8" px="4">
        <Heading as="h1" textAlign="center" mb="4">wasmCloud Image Recognition</Heading>

        <Grid templateColumns={{ base: "1fr", md: "3fr 2fr" }} gap={6}>
          <Box>
            <VStack spacing={4} align="start">
              <Flex justifyContent="flex-start" width="full" mb="4">
                <Select placeholder="Select Model" onChange={(e) => setModel(e.target.value)} maxWidth="200px">
                  <option value="mobilenetv27">Mobilenet v2.7</option>
                  <option value="resnet152v27">Resnet 152 v2-7</option>
                </Select>

                <Select placeholder="Select Priority" onChange={(e) => setPriority(e.target.value)} maxWidth="200px" ml="2" mr="2">
                  <option value="privacy">Privacy</option>
                  <option value="accuracy">Accuracy</option>
                  <option value="latency">Latency</option>
                </Select>

                <Box as="label" htmlFor="file-upload" mb="2">
                  <Input
                    variant="outline"
                    type="file"
                    id="file-upload"
                    onChange={handleImageUpload}
                    accept=".bmp,.png,.jpg,.jpeg"
                    hidden
                  />
                  <Button as="span" role="button" size="md" colorScheme="blue">
                    Upload Image
                  </Button>
                </Box>
              </Flex>

              <div width="800px">
                {imageSrc && (
                  <Image
                    src={imageSrc}
                    alt="Image Input"
                    margin="0 auto"
                    display="block"
                    maxWidth="100%"
                    borderRadius="md"
                    boxShadow="lg"
                  />
                )}
              </div>

            </VStack>
          </Box>

          <Box>
            <Heading as="h3" mb="4">Inference Results</Heading>
            {results.length === 0 && <span>Upload image to perform inference</span>}
            <Box id="run_time" mb="4">{runTime}</Box>
            <Box id="output">
              {results.length > 0 && (
                <Table variant="simple">
                  <Thead>
                    <Tr>
                      <Th>Label</Th>
                      <Th>Probability</Th>
                    </Tr>
                  </Thead>
                  <Tbody>
                    {results.map((result, index) => (
                      <Tr key={index}>
                        <Td>{result.label}</Td>
                        <Td textAlign="right">{Math.round(result.probability * 10000) / 100}%</Td>
                      </Tr>
                    ))}
                  </Tbody>
                </Table>
              )}
            </Box>
          </Box>
        </Grid>
      </Box>
    </ChakraProvider>

  );
}

export default App;
