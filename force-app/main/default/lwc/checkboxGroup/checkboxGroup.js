import { LightningElement } from 'lwc';

export default class CheckboxGroup extends LightningElement {
    value =[];

    get options(){
        console.log('get 1');
        return [
            {label: 'Aman', value: 'option1'},
            {label: 'Bhagya', value: 'option2'},
            {label: 'Ankit', value: 'option3'},
            {label: 'Annu', value: 'option4'},
            {label: 'Chandu', value: 'option5'},
            {label: 'Dhruv', value: 'option6'}
        ]
    }

    get selectedValues(){
        console.log('get run');
        return this.value.join(',');
    }

    handleChange(e){
        this.value = e.detail.value;
        console.log(e.detail.value);
        console.log(e.detail);
    }


    
}