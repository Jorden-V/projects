exports.testService = async () => {
  try {
    console.log("Hello World");
    console.log("Dummy change");
    res.status(200).send(`Success!`);
  } catch (error) {
    throw error;
  }
};
