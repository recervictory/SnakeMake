function addCondition() {
  const fieldsDiv = document.getElementById("fields");
  const newCondition = document.createElement("div");
  newCondition.innerHTML = `
    <div class="condition">
      <label for="condition-name">Condition Name:</label>
      <input type="text" name="condition-name[]" class="condition-name">
      <button type="button" onclick="addSubCondition(this)">Add Condition</button>
      <button type="button" onclick="addSample(this)">Add Sample</button>
      <button type="button" onclick="removeCondition(this)">Remove Condition</button>
      <div class="sub-conditions"></div>
      <div class="samples"></div>
    </div>
  `;
  fieldsDiv.appendChild(newCondition);
}

function addSubCondition(button) {
  const parentDiv = button.parentNode;
  const newSubCondition = document.createElement("div");
  newSubCondition.innerHTML = `
    <div class="sub-condition">
      <label for="sub-condition-name">Sub-Condition Name:</label>
      <input type="text" name="sub-condition-name[]" class="sub-condition-name">
      <button type="button" onclick="addSubCondition(this)">Add Condition</button>
      <button type="button" onclick="addSample(this)">Add Sample</button>
      <button type="button" onclick="removeCondition(this)">Remove Condition</button>
      <div class="sub-conditions"></div>
      <div class="samples"></div>
    </div>
  `;
  parentDiv.querySelector(".sub-conditions").appendChild(newSubCondition);
}

function addSample(button) {
  const parentDiv = button.parentNode;
  const newSample = document.createElement("div");
  newSample.innerHTML = `
    <div class="sample">
      <label for="sample-name">Sample Name:</label>
      <input type="text" name="sample-name[]" class="sample-name">
      <button type="button" onclick="removeSample(this)">Remove Sample</button>
    </div>
  `;
  parentDiv.querySelector(".samples").appendChild(newSample);
}

function removeCondition(button) {
  const parentDiv = button.parentNode;
  parentDiv.remove();
}

function removeSample(button) {
  const parentDiv = button.parentNode;
  parentDiv.remove();
}

function saveData() {
  const conditions = [];
  const conditionDivs = document.querySelectorAll(".condition");
  conditionDivs.forEach((conditionDiv) => {
    const conditionName = conditionDiv.querySelector(
      "input[name='condition-name[]']"
    ).value;
    const subConditions = [];
    const subConditionDivs = conditionDiv.querySelectorAll(".sub-condition");
    if (subConditionDivs.length === 0) {
      const samples = [];
      const sampleDivs = conditionDiv.querySelectorAll(".sample");
      sampleDivs.forEach((sampleDiv) => {
        const sampleName = sampleDiv.querySelector(
          "input[name='sample-name[]']"
        ).value;
        samples.push(sampleName);
      });
      conditions.push({ name: conditionName, samples: samples });
    } else {
      subConditionDivs.forEach((subConditionDiv) => {
        const subConditionName = subConditionDiv.querySelector(
          "input[name='sub-condition-name[]']"
        ).value;
        const samples = [];
        const sampleDivs = subConditionDiv.querySelectorAll(".sample");
        sampleDivs.forEach((sampleDiv) => {
          const sampleName = sampleDiv.querySelector(
            "input[name='sample-name[]']"
          ).value;
          samples.push(sampleName);
        });
        subConditions.push({ name: subConditionName, samples: samples });
      });
      conditions.push({ name: conditionName, subConditions: subConditions });
    }
  });
  const jsonData = JSON.stringify({ conditions: conditions });
  const blob = new Blob([jsonData], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = "design.json";
  a.click();
}

// ! ------------------------
const form = document.querySelector("form");

form.addEventListener("submit", (event) => {
  event.preventDefault();

  const config = {
    meta: {
      name: form.elements.name.value,
      design: form.elements.design.value,
    },
    fastqc: {
      run: form.elements.fastqc_run.checked,
    },
    cudaAdapt: {
      run: form.elements.cudaAdapt_run.checked,
      adapter_a: form.elements.adapter_a.value,
      adapter_A: form.elements.adapter_A.value,
      cpu_cores: form.elements.cpu_cores.value,
      quality_score_threshold: form.elements.quality_score_threshold.value,
      min_length_threshold: form.elements.min_length_threshold.value,
    },
    trimmed_fastqc: {
      run: form.elements.trimmed_fastqc_run.checked,
    },
    starIndex: {
      run: form.elements.cudaAdapt_run.checked,
      gtf_path: form.elements.gtf_path.value.split("\\").pop().split("/").pop(),
      ref_path: form.elements.ref_path.value.split("\\").pop().split("/").pop(),
      cpu_cores: form.elements.star_index_cpu_cores.value,
      genome_ram_limit: form.elements.genome_ram_limit.value,
    },
    starMapping: {
      cpu_cores: form.elements.star_map_cpu_cores.value,
      limitBAMsortRAM: form.elements.limitBAMsortRAM.value,
      runMode: form.elements.runMode.value,
      readFilesCommand: form.elements.runMode.value,
      quantMode: [],
      outSAMtype: form.elements.outSAMtype.value,
    },
  };
  if (form.elements.geneCounts.checked) {
    config.starMapping.quantMode.push(form.elements.geneCounts.value);
  }
  if (form.elements.transcriptomeSAM.checked) {
    config.starMapping.quantMode.push(form.elements.transcriptomeSAM.value);
  }

  const file = new Blob([JSON.stringify(config)], {
    type: "application/json",
  });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(file);
  a.download = "config.json";
  a.click();
});
